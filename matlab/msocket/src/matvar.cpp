////////////////////////////////////////////////////////////
//
// Name:   matvar.cpp
//
// Author: Steven Michael (smichael@ll.mit.edu)
//
// Date:   5/19/06
//
// Description:
//
//    The "MatVar" class encapsulates serialization and 
//    unserialization of MATLAB variables.  All variable
//    types, with the exception of function handles, are
//    supported.  The serialization class is useful for 
//    sending variables over sockets, MPI, etc..
//
// Copyright (c) 2006 MIT Lincoln Laboratory
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, 
// Boston, MA  02110-1301  USA
//
////////////////////////////////////////////////////////////

#include <matvar.h>
#include <mex.h>

#include <string.h>
#if defined(WIN32)
#define strncpy(a,b,c) strncpy_s(a,c,b,_TRUNCATE)
#define strcpy(a,b) strcpy_s(a,strlen(b)+1,b)
#endif

const int MatVar::varSize[MAT_VAREND] = 
	{0,
	 sizeof(mxLogical),
	 sizeof(mxChar),
	 1,1,2,2,4,4,8,8,4,8,sizeof(char *),sizeof(char *)
	};


#ifdef _BIG_ENDIAN_
void MatVar::swap4(unsigned char *c)
{
	unsigned char tmp;
	tmp = c[0];c[0] = c[3];c[3] = tmp;
	tmp = c[1];c[1] = c[2];c[2] = tmp;
}
void MatVar::swap2(unsigned char *c)
{
	unsigned char tmp;
	tmp = c[0];c[0] = c[1];c[1] = tmp;
}

void MatVar::swap8(unsigned char *c)
{
	unsigned char tmp;
	tmp = c[0];c[0] = c[7];c[7] = tmp;
	tmp = c[1];c[1] = c[6];c[6] = tmp;
	tmp = c[2];c[2] = c[5];c[5] = tmp;
	tmp = c[3];c[3] = c[4];c[4] = tmp;
}

void MatVar::swaparr(unsigned char *c, int numel, int size)
{
	switch(size) {
	case 2:		
		for(int i=0;i<numel;i++) 
			swap2(c+i*2);
		break;
	case 4:
		for(int i=0;i<numel;i++)
			swap4(c+i*4);
		break;
	case 8:
		for(int i=0;i<numel;i++)
			swap8(c+i*8);
		break;
	default:
		break;
	}
	return;
}

#endif

MatVar::MatVar(const mxArray *mx)
{
	MatVar();
	create(mx);
	return;
}

MatVar::MatVar()
{
	pr = (void *)0;
	pi = (void *)0;
	children = (MatVar *)0;
	nFields = 0;
	nchildren = 0;
	varType = MAT_DOUBLE;
	varComplexity = MAT_REAL;
	ndim = 2;
	dims[0] = dims[1] = 0;
	fieldNames = (char **)0;
	return;
}

MatVar::~MatVar()
{
	if(fieldNames) {
		for(int i=0;i<nFields;i++) {
			if(fieldNames[i])
				delete[] fieldNames[i];
		}
		delete[] fieldNames;
	}
	if(children)
		delete[] children;
	return;
} // end of destrutor


mxArray *MatVar::get_mxarray(void)
{
	mxClassID id=mxCHAR_CLASS;
	mxComplexity cmplx=mxREAL;

	switch(varType) {
	case MAT_CHAR:
		id = mxCHAR_CLASS;
		break;
	case MAT_UINT8:
		id = mxUINT8_CLASS;
		break;
	case MAT_INT8:
		id = mxINT8_CLASS;
		break;
	case MAT_UINT16:
		id = mxUINT16_CLASS;
		break;
	case MAT_INT16:
		id = mxINT16_CLASS;
		break;
	case MAT_UINT32:
		id = mxUINT32_CLASS;
		break;
	case MAT_INT32:
		id = mxINT32_CLASS;
		break;
	case MAT_UINT64:
		id = mxUINT64_CLASS;
		break;
	case MAT_INT64:
		id = mxINT64_CLASS;
		break;
	case MAT_SINGLE:
		id = mxSINGLE_CLASS;
		break;
	case MAT_DOUBLE:
		id = mxDOUBLE_CLASS;
		break;
	case MAT_STRUCT:
		id = mxSTRUCT_CLASS;
		break;
	case MAT_CELL:
		id = mxCELL_CLASS;
		break;
	case MAT_EMPTY:
		return (mxArray *)0;
	default:
		break;
	}
					 
	int numel=1;
	for(mwSize i=0;i<ndim;i++)
		numel *= (int) dims[i];

	mxArray *mx;
	switch(varType) {
	case MAT_LOGICAL:
		mx = mxCreateLogicalArray(ndim,dims);
		memcpy(mxGetLogicals(mx),pr,sizeof(mxLogical)*numel);
		break;
	case MAT_STRUCT:
		mx = 
			mxCreateStructArray(ndim,dims,nFields,
													(const char **)fieldNames);
		for(int i=0;i<numel;i++) {									
			for(int j=0;j<nFields;j++) {
				mxSetFieldByNumber(mx,i,j,
					children[i*nFields+j].get_mxarray());
			}
		}
		break;
		/// Is this a cell array
	case MAT_CELL:
		mx = 
			mxCreateCellArray(ndim,dims);
		for(int i=0;i<numel;i++) {
			mxSetCell(mx,i,children[i].get_mxarray());
		}
		break;
		// Default is numeric data
	default:
		if(varComplexity == MAT_REAL)
			cmplx = mxREAL;
		else
			cmplx = mxCOMPLEX;
		mx = 
			mxCreateNumericArray(ndim,dims,id,cmplx);
		memcpy(mxGetPr(mx),pr,numel*varSize[(int)varType]);
		if(varComplexity == MAT_COMPLEX)
			memcpy(mxGetPi(mx),pi,numel*varSize[(int)varType]);
		break;
	}

	return mx;
} // end of get_array

int MatVar::create_cell(const mxArray *mx)
{
	ndim = mxGetNumberOfDimensions(mx);
	memcpy(dims,mxGetDimensions(mx),sizeof(mwSize)*ndim);

	nchildren = 1;
	nFields = 0;
	for(mwSize i=0;i<ndim;i++)
		nchildren *= (int)dims[i];

	children = new MatVar[nchildren];
	for(int i=0;i<nchildren;i++) 
		children[i].create(mxGetCell(mx,i));
	return 0;
}

int MatVar::create_struct(const mxArray *mx)
{
	int numel;
	ndim = mxGetNumberOfDimensions(mx);
	memcpy(dims,mxGetDimensions(mx),sizeof(mwSize)*ndim);
	nFields = mxGetNumberOfFields(mx);

	numel=1;
	for(mwSize i=0;i<ndim;i++)
		numel *= (int) dims[i];
	nchildren = nFields*numel;

	typedef char *charptr;
	fieldNames = new charptr[nFields];
	for(int i=0;i<nFields;i++) {
		const char *fldname = mxGetFieldNameByNumber(mx,i);
		fieldNames[i] = new char[strlen(fldname)+1];
		memcpy(fieldNames[i],fldname,strlen(fldname));
		fieldNames[i][strlen(fldname)] = '\0';
	}

	children = new MatVar[nchildren];
	int cnt = 0;
	for(int i=0;i<numel;i++) {
		for(int j=0;j<nFields;j++) {
			children[cnt++].create(mxGetFieldByNumber(mx,i,j));
		}
	}
	return 0;
}

int MatVar::create(const mxArray *mx)
{
	if(!mx) {
		varType = MAT_EMPTY;
		return 0;
	}
	switch(mxGetClassID(mx)) {
	case mxCHAR_CLASS:
		varType = MAT_CHAR;
		break;
	case mxUINT8_CLASS:
		varType = MAT_UINT8;
		break;
	case mxINT8_CLASS:
		varType = MAT_INT8;
		break;
	case mxUINT16_CLASS:
		varType = MAT_UINT16;
		break;
	case mxINT16_CLASS:
		varType = MAT_INT16;
		break;
	case mxUINT32_CLASS:
		varType = MAT_UINT32;
		break;
	case mxINT32_CLASS:
		varType = MAT_INT32;
		break;
	case mxUINT64_CLASS:
		varType = MAT_UINT64;
		break;
	case mxINT64_CLASS:
		varType = MAT_INT64;
		break;
	case mxSINGLE_CLASS:
		varType = MAT_SINGLE;
		break;
	case mxDOUBLE_CLASS:
		varType = MAT_DOUBLE;
		break;
	case mxLOGICAL_CLASS:
		varType = MAT_LOGICAL;
		break;
	case mxSTRUCT_CLASS:
		varType = MAT_STRUCT;
		return create_struct(mx);
		break;
	case mxCELL_CLASS:
		varType = MAT_CELL;
		return create_cell(mx);
		break;
	default:
		printf("Unknown class\n");
		return-1;
	}
	if(mxIsComplex(mx) ==0)
		varComplexity = MAT_REAL;
	else
		varComplexity = MAT_COMPLEX;
	ndim = mxGetNumberOfDimensions(mx);
	memcpy(dims,mxGetDimensions(mx),sizeof(mwSize)*ndim);

	if(varType == MAT_LOGICAL)
		pr = mxGetLogicals(mx);
	else {
		pr = mxGetPr(mx);
		if(varComplexity == MAT_COMPLEX)
			pi = mxGetPi(mx);
		else
			pi = (void *)0;
	}
	return 0;
} // end of create

int MatVar::get_serialize_length(void)
{
	int len=0;

	if(varType == MAT_STRUCT)  {
		len = sizeof(MatVarType) + 
			(int) (sizeof(int)*(ndim+1) + sizeof(int));
		for(int i=0;i<nFields;i++) 
			len += (int)strlen(fieldNames[i])+1;
		for(int i=0;i<nchildren;i++)
			len += children[i].get_serialize_length();
	}
	else if(varType == MAT_CELL) {
		len = sizeof(MatVarType) + (int)(sizeof(int)*(ndim+1));
		for(int i=0;i<nchildren;i++)
			len += children[i].get_serialize_length();
	}
	else if(varType == MAT_EMPTY) 
		len = sizeof(MatVarType);
	else {
		int numel=1;
		for(mwSize i=0;i<ndim;i++)
			numel *= (int)dims[i];
		len = sizeof(MatVarType)+sizeof(MatVarComplexity)+sizeof(int)+
			(int)(sizeof(int)*ndim)+numel*varSize[(int)varType];
		if(varComplexity == MAT_COMPLEX)
			len += numel*varSize[(int)varType];
	}
	return len;

}// end of get_serialize_length


int MatVar::serialize_cell(void *data)
{
	char *cdata = (char *)data;
	((MatVarType *)cdata)[0] = varType;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,1,sizeof(MatVarType));
#endif
	cdata += sizeof(MatVarType);
	((int *)cdata)[0] = (int)ndim;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char*)cdata,1,sizeof(int));
#endif
	cdata += sizeof(int);
	for(mwSize i=0;i<ndim;i++)
		((int *)cdata)[i] = (int) dims[i];
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,ndim,sizeof(int));
#endif
	cdata += sizeof(int)*ndim;
	for(int i=0;i<nchildren;i++) {
		children[i].serialize(cdata);
		cdata += children[i].get_serialize_length();
	}
	return 0;
} // end of serialize_cell

int MatVar::serialize_struct(void *data)
{
	char *cdata = (char *)data;
	((MatVarType *)cdata)[0] = varType;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,1,sizeof(MatVarType));
#endif
	cdata += sizeof(MatVarType);
	((int *)cdata)[0] = (int)ndim;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,1,sizeof(int));
#endif
	cdata += sizeof(int);
	for(mwSize i=0;i<ndim;i++) 
		((int *)cdata)[i] = (int) dims[i];
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char*)cdata,ndim,sizeof(int));
#endif
	cdata += sizeof(int)*ndim;
	((int *)cdata)[0] = nFields;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,1,sizeof(int));
#endif
	cdata += sizeof(int);
	for(int i=0;i<nFields;i++) {
		memcpy(cdata,fieldNames[i],strlen(fieldNames[i]));
		cdata += strlen(fieldNames[i]);
		cdata[0] = '\0';
		cdata++;
	}
	for(int i=0;i<nchildren;i++) {
		children[i].serialize(cdata);
		cdata += children[i].get_serialize_length();
	}
	return 0;
} // end of serialize_struct

int MatVar::serialize(void *data)
{

	if(varType == MAT_STRUCT)
		return serialize_struct(data);
	else if(varType == MAT_CELL)
		return serialize_cell(data);
	else if(varType == MAT_EMPTY) {
		((MatVarType *)data)[0] = MAT_EMPTY;
		return 0;
	}
	// The rest of this serializes numeric data
	int numel=1;
	for(mwSize i=0;i<ndim;i++)
		numel *= (int)dims[i];


	unsigned char *cdata = (unsigned char *)data;
	((MatVarType *)cdata)[0] = varType;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,1,sizeof(MatVarType));
#endif
	cdata += sizeof(MatVarType);
	((MatVarComplexity *)cdata)[0] = varComplexity;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,1,sizeof(MatVarComplexity));
#endif
	cdata += sizeof(MatVarComplexity);
	((int *)cdata)[0] = (int)ndim;
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,1,sizeof(int));
#endif
	cdata += sizeof(int);
	for(mwSize i=0;i<ndim;i++) 
		((int *)cdata)[i] = (int) dims[i];
#ifdef _BIG_ENDIAN_
	swaparr((unsigned char *)cdata,ndim,sizeof(int));
#endif
	cdata += sizeof(int)*ndim;
	

	memcpy(cdata,pr,varSize[(int)varType]*numel);
#ifdef _BIG_ENDIAN_
	swaparr(cdata,numel,varSize[(int)varType]);
#endif
	if(varComplexity == MAT_COMPLEX) {
		cdata += varSize[(int)varType]*numel;
		memcpy(cdata,pi,varSize[(int)varType]*numel);
#ifdef _BIG_ENDIAN_
		swaparr(cdata,numel,varSize[(int)varType]);
#endif
	}
	return 0;
} // end of serialize

MatVar *MatVar::unserialize(void *data)
{
	MatVar *mv = new MatVar;
	mv->create(data);
	return mv;
} // end of unserialize

int MatVar::create(void *data)
{
	unsigned char *cdata = (unsigned char *)data;
	typedef char *charptr;
	int numel=1;

#ifdef _BIG_ENDIAN_
	swaparr(cdata,1,sizeof(MatVarType));
#endif
	varType = ((MatVarType *)cdata)[0];
	cdata += sizeof(MatVarType);
	switch(varType) {
	case MAT_EMPTY:
		return 0;
	case MAT_CELL:
#ifdef _BIG_ENDIAN_
		swaparr(cdata,1,sizeof(int));
#endif
		ndim = ((int *)cdata)[0];
		cdata += sizeof(int);
#ifdef _BIG_ENDIAN_
		swaparr(cdata,ndim,sizeof(int));
#endif
		for(mwSize i=0;i<ndim;i++) 
			dims[i] = (mwSize) ((int *)cdata)[i];
		cdata += sizeof(int)*ndim;
		nchildren = 1;
		for(mwSize i=0;i<ndim;i++) {
			nchildren *= (int)dims[i];
		}
		children = new MatVar[nchildren];
		for(int i=0;i<nchildren;i++) {
			children[i].create(cdata);
			cdata += children[i].get_serialize_length();
		}
		break;
	case MAT_STRUCT:
#ifdef _BIG_ENDIAN_
		swaparr(cdata,1,sizeof(int));
#endif
		ndim = ((int *)cdata)[0];
		cdata += sizeof(int);
#ifdef _BIG_ENDIAN_
		swaparr(cdata,ndim,sizeof(int));
#endif
		for(mwSize i=0;i<ndim;i++) 
			dims[i] = (mwSize) ((int *)cdata)[i];
		cdata += sizeof(int)*ndim;
#ifdef _BIG_ENDIAN_
		swaparr(cdata,1,sizeof(int));
#endif
		nFields = ((int *)cdata)[0];
		cdata += sizeof(int);
		fieldNames = new charptr[nFields];
		for(int i=0;i<nFields;i++) {
			fieldNames[i] = 
				new char[strlen((const char *)cdata)+1];
			strcpy(fieldNames[i],(const char *)cdata);
			cdata += strlen((const char *)cdata)+1;
		}
		nchildren = 1;
		numel = 1;
		for(mwSize i=0;i<ndim;i++) {
			nchildren *= (int)dims[i];
			numel *= (int)dims[i];
		}
		nchildren *= nFields;
		children = new MatVar[nchildren];
		for(int i=0;i<numel;i++) {
			for(int j=0;j<nFields;j++) {
				children[i*nFields+j].create(cdata);
				cdata += 
					children[i*nFields+j].get_serialize_length();
			}
		}
		break;
	default:
		// Operate on all non-cell, non-struct types
#ifdef _BIG_ENDIAN_
		swaparr(cdata,1,sizeof(MatVarComplexity));
#endif
		varComplexity = ((MatVarComplexity *)cdata)[0];
		cdata += sizeof(MatVarComplexity);
#ifdef _BIG_ENDIAN_
		swaparr(cdata,1,sizeof(int));
#endif
		ndim = ((int *)cdata)[0];
		cdata += sizeof(int);
#ifdef _BIG_ENDIAN_
		swaparr(cdata,ndim,sizeof(int));
#endif
		for(mwSize i=0;i<ndim;i++) 
			dims[i] = (mwSize) ((int *)cdata)[i];
		cdata += sizeof(int)*ndim;

		numel=1;
		for(mwSize i=0;i<ndim;i++)
			numel = numel*(int)dims[i];

		pr = (void *)cdata;	
		if(varComplexity == MAT_COMPLEX) {		
			cdata += MatVar::varSize[(int)varType]*numel;
			pi = (void *)cdata;
		}
		else 
			pi = (void *)0;		
		// Swap byte order on the data if this is a big-endian machine
		// (serialized data is always stored in little-endian format)
#ifdef _BIG_ENDIAN_
		unsigned char *c = (unsigned char *)pr;
		swaparr(c,numel,MatVar::varSize[(int)varType]);
		if(pi) {
			c = (unsigned char *)pi;
			swaparr(c,numel,MatVar::varSize[(int)varType]);
		}
#endif
		break;
	} // end of switch on var types
	return 0;
} // end of unserialize
	
