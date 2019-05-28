#include <sys.h>
#include "error.h"
#include "open.h"

  int
open_append(const char *fn)
{
  int fd;

#ifdef WIN32
  fd = open(fn, O_WRONLY | O_CREAT | O_APPEND | O_BINARY, 0600);
#else
  fd = open(fn, O_WRONLY | O_CREAT | O_APPEND | O_NONBLOCK, 0600);
#endif
  if (fd == -2) {
    fd = -1;
    errno = error_noent;
  }
  return fd;
}
