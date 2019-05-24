#include <unistd.h>
#include "buffer.h"
#include "strerr.h"

#define FATAL "un%: fatal: "

#define safe_buffer_flush(b) if (buffer_flush((b)) == -1) strerr_die2sys(1, FATAL, "error flushing buffer: ")
#define safe_buffer_putc(b,c) if (buffer_putc((b), (c)) == -1) strerr_die2sys(1, FATAL, "error writing to buffer: ")

  static int
dehex(const char c)
{
  if (c >= '0' && c <= '9') return c - '0' + 0x0;
  if (c >= 'A' && c <= 'F') return c - 'A' + 0xA;
  if (c >= 'a' && c <= 'f') return c - 'a' + 0xa;
  return -1;
}

  int
main(int argc, const char **argv)
{
  char c, k;

  while (buffer_getc(buffer_0, &c) > 0) {
    if (c != '%') safe_buffer_putc(buffer_1, c);
    else {
      if (buffer_getc(buffer_0, &k) == -1) strerr_die2x(1, FATAL, "incomplete percent-encoded sequence");
      k = dehex(k);
      if (k == -1) strerr_die2x(1, FATAL, "invalid percent-encoded sequence");

      if (buffer_getc(buffer_0, &c) == -1) strerr_die2x(1, FATAL, "incomplete percent-encoded sequence");
      c = dehex(c);
      if (c == -1) strerr_die2x(1, FATAL, "invalid percent-encoded sequence");

      safe_buffer_putc(buffer_1, (char)(k * 0x10 + c));
    }
  }
  safe_buffer_flush(buffer_1);
  _exit(0);
}
