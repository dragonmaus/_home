#include <unistd.h>
#include "buffer.h"
#include "path.h"
#include "str.h"
#include "strerr.h"

#define FATAL "abspath: fatal: "
#define SIZE 4096

#define safe_buffer_flush(b) if (buffer_flush((b)) == -1) strerr_die2sys(1, FATAL, "error flushing buffer: ")
#define safe_buffer_putc(b,c) if (buffer_putc((b), (c)) == -1) strerr_die2sys(1, FATAL, "error writing to buffer: ")
#define safe_buffer_puts(b,s) if (buffer_puts((b), (s)) == -1) strerr_die2sys(1, FATAL, "error writing to buffer: ")

  int
main(int argc, const char **argv)
{
  char path[SIZE];
  int len;

  if (!--argc) {
    str_copy(path, ".");
    if (path_absolute(path, SIZE) == -1) strerr_die2sys(1, FATAL, "unable to process current path: ");
    safe_buffer_puts(buffer_1, path);
    safe_buffer_putc(buffer_1, '\n');
    safe_buffer_flush(buffer_1);
  } else while (*++argv) {
    str_copy(path, *argv);
    if (path_absolute(path, SIZE) == -1) strerr_die4sys(1, FATAL, "unable to process path '", *argv, "': ");
    safe_buffer_puts(buffer_1, path);
    safe_buffer_putc(buffer_1, '\n');
    safe_buffer_flush(buffer_1);
  }
  _exit(0);
}
