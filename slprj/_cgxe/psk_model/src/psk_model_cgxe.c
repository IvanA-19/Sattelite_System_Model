/* Include files */

#include "psk_model_cgxe.h"
#include "m_8VCvJ3yT74EEBcCqdl5ZQD.h"

unsigned int cgxe_psk_model_method_dispatcher(SimStruct* S, int_T method, void
  * data)
{
  if (ssGetChecksum0(S) == 412575118 &&
      ssGetChecksum1(S) == 1111203489 &&
      ssGetChecksum2(S) == 3315102871 &&
      ssGetChecksum3(S) == 2076054340) {
    method_dispatcher_8VCvJ3yT74EEBcCqdl5ZQD(S, method, data);
    return 1;
  }

  return 0;
}
