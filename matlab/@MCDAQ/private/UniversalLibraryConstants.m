function ULconstants = UniversalLibraryConstants

% relevant constants (taken from cbw.h)
ULconstants.PRINTALL = 3;
ULconstants.DONTSTOP = 0;
ULconstants.DIGITALOUT = 1;
ULconstants.DIGITALIN = 2;
ULconstants.AUXPORT = 1;
ULconstants.FIRSTPORTA = 10;
ULconstants.FIRSTPORTB = 11;

% not from cbw.h
ULconstants.ANALOGOUT = 3;
ULconstants.ANALOGIN = 4;
ULconstants.ANALOGINDIGITALOUT = 5;


% Selectable A/D Ranges codes

ULconstants.BIP60VOLTS =      20;   %        /* -60 to 60 Volts */
ULconstants.BIP30VOLTS =	  23;   %
ULconstants.BIP20VOLTS =      15;   %        /* -20 to +20 Volts */
ULconstants.BIP15VOLTS =      21;   %        /* -15 to +15 Volts */
ULconstants.BIP10VOLTS =      1;    %        /* -10 to +10 Volts */
ULconstants.BIP5VOLTS  =      0;    %        /* -5 to +5 Volts */
ULconstants.BIP4VOLTS  =      16;   %        /* -4 to + 4 Volts */
ULconstants.BIP2PT5VOLTS  =   2;    %        /* -2.5 to +2.5 Volts */
ULconstants.BIP2VOLTS     =   14;   %        /* -2.0 to +2.0 Volts */
ULconstants.BIP1PT25VOLTS =   3;    %        /* -1.25 to +1.25 Volts */
ULconstants.BIP1VOLTS     =   4;    %        /* -1 to +1 Volts */
ULconstants.BIPPT625VOLTS =   5;    %        /* -.625 to +.625 Volts */
ULconstants.BIPPT5VOLTS   =   6;    %        /* -.5 to +.5 Volts */
ULconstants.BIPPT25VOLTS  =   12;   %        /* -0.25 to +0.25 Volts */
ULconstants.BIPPT2VOLTS   =   13;   %        /* -0.2 to +0.2 Volts */
ULconstants.BIPPT1VOLTS   =   7;    %        /* -.1 to +.1 Volts */
ULconstants.BIPPT05VOLTS  =   8;    %        /* -.05 to +.05 Volts */
ULconstants.BIPPT01VOLTS  =   9;    %        /* -.01 to +.01 Volts */
ULconstants.BIPPT005VOLTS =   10;   %        /* -.005 to +.005 Volts */
ULconstants.BIP1PT67VOLTS =   11;   %        /* -1.67 to +1.67 Volts */
ULconstants.BIPPT312VOLTS =   17;	%		 /* -0.312 to +0.312 Volts */
ULconstants.BIPPT156VOLTS =   18;	%		 /* -0.156 to +0.156 Volts */
ULconstants.BIPPT125VOLTS =   22;	%		 /* -0.125 to +0.125 Volts */
ULconstants.BIPPT078VOLTS =   19;	%		 /* -0.078 to +0.078 Volts */


ULconstants.UNI10VOLTS    =   100;  %        /* 0 to 10 Volts*/
ULconstants.UNI5VOLTS     =   101;  %        /* 0 to 5 Volts */
ULconstants.UNI4VOLTS     =   114;  %        /* 0 to 4 Volts */
ULconstants.UNI2PT5VOLTS  =   102;  %        /* 0 to 2.5 Volts */
ULconstants.UNI2VOLTS     =   103;  %        /* 0 to 2 Volts */
ULconstants.UNI1PT67VOLTS =   109;  %        /* 0 to 1.67 Volts */
ULconstants.UNI1PT25VOLTS =   104;  %        /* 0 to 1.25 Volts */
ULconstants.UNI1VOLTS     =   105;  %        /* 0 to 1 Volt */
ULconstants.UNIPT5VOLTS   =   110;  %        /* 0 to .5 Volt */
ULconstants.UNIPT25VOLTS  =   111;  %        /* 0 to 0.25 Volt */
ULconstants.UNIPT2VOLTS   =   112;  %        /* 0 to .2 Volt */
ULconstants.UNIPT1VOLTS   =   106;  %        /* 0 to .1 Volt */
ULconstants.UNIPT05VOLTS  =   113;  %        /* 0 to .05 Volt */
ULconstants.UNIPT02VOLTS  =   108;  %        /* 0 to .02 Volt*/
ULconstants.UNIPT01VOLTS  =   107;  %        /* 0 to .01 Volt*/

% Types of configuration information
ULconstants.GLOBALINFO   =      1;
ULconstants.BOARDINFO    =      2;
ULconstants.DIGITALINFO  =      3;
ULconstants.COUNTERINFO  =      4;
ULconstants.EXPANSIONINFO=      5;
ULconstants.MISCINFO     =      6;
ULconstants.EXPINFOARRAY =      7;
ULconstants.MEMINFO      =      8;

% Type of digital device information
ULconstants.DIBASEADR     =      0; %      /* Base address */
ULconstants.DIINITIALIZED =      1; %      /* TRUE or FALSE */
ULconstants.DIDEVTYPE     =      2; %      /* AUXPORT or xPORTA - CH */
ULconstants.DIMASK        =      3; %      /* Bit mask for this port */
ULconstants.DIREADWRITE   =      4; %      /* Read required before write */
ULconstants.DICONFIG      =      5; %     /* Current configuration */
ULconstants.DINUMBITS     =      6; %     /* Number of bits in port */
ULconstants.DICURVAL      =      7; %     /* Current value of outputs */
ULconstants.DIINMASK      =      8; %     /* Input bit mask for port */
ULconstants.DIOUTMASK     =      9; %     /* Output bit mask for port */
