////////////////////////////////////////////////////////////
//
// Name:   matvar.h
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

#ifndef _MATVAR_H_
#define _MATVAR_H_

typedef enum {
	MAT_EMPTY = 0,
	MAT_LOGICAL = 1,
	MAT_CHAR = 2,
	MAT_UINT8 = 3,
	MAT_INT8 = 4,
	MAT_UINT16 = 5,
	MAT_INT16 = 6,
	MAT_UINT32 = 7,
	MAT_INT32 = 8,
	MAT_UINT64 = 9,
	MAT_INT64 = 10,
	MAT_FLOAT32 = 11,
	MAT_SINGLE = 11,
	MAT_FLOAT64 = 12,
	MAT_DOUBLE = 12,
	MAT_STRUCT = 13,
	MAT_CELL = 14,
	MAT_VAREND = 15
} MatVarType;

typedef enum {
	MAT_REAL = 0,
	MAT_COMPLEX = 1
} MatVarComplexity;

#define MAX_DIMS 32

//typedef struct mxArray;
#include <mex.h>


class MatVar {
 public:
	MatVar();
	MatVar(const mxArray *mx);

	virtual ~MatVar();

	int get_serialize_length(void);
	int serialize(void *data);

	static MatVar *unserialize(void *data);

	int create(void *data);
	int create(const mxArray *);
	mxArray *get_mxarray(void);
	
	mwSize ndim;
	mwSize dims[MAX_DIMS];
	MatVarType varType;
	MatVarComplexity varComplexity;

	static const int varSize[MAT_VAREND]; 

#ifdef _BIG_ENDIAN_
	static void swap4(unsigned char *);
	static void swap2(unsigned char *);
	static void swap8(unsigned char *);
	static void swaparr(unsigned char *, int numel,int size);
#endif
	
	int create_cell(const mxArray *mx);
	int create_struct(const mxArray *mx);
	int serialize_cell(void *data);
	int serialize_struct(void *data);

 protected:
	void *pr;
	void *pi;

	MatVar *children;
	int    nchildren;
	int    nFields;
	char **fieldNames;	
};
		
							
#endif
