Off Statistics;

CFunction a, d;
Symbol r0, nu, I;

#define inFile "`FORM_DIR'`WKB_SUBDIR'standardEquation_`eqNum'.frm"
#define outFile "`FORM_DIR'`WKB_SUBDIR'expandedEquations_`eqNum'.m"

#include coeffs.frm
#include dvars.frm
#include `inFile'

#ifdef Eq`eqNum'
  Local EqExpanded`eqNum' = Eq`eqNum';
  .sort
  Format mathematica;
  Format nospaces, nolines;
  #write <`outFile'> "%E==0\n", EqExpanded`eqNum'
#else
  #message Warning: Eq`eqNum' not defined in `inFile'
#endif
.end

