#include <unistd.h>
#include "buffer.h"
#include "env.h"
#include "option.h"
#include "strerr.h"

#define FATAL "printenv: fatal: "
#define USAGE "usage: printenv [-hz] [name...]"

#define safe_buffer_flush(b) if (buffer_flush((b)) == -1) strerr_die2sys(1, FATAL, "error flushing buffer: ")
#define safe_buffer_putc(b,c) if (buffer_putc((b), (c)) == -1) strerr_die2sys(1, FATAL, "error writing to buffer: ")
#define safe_buffer_puts(b,s) if (buffer_puts((b), (s)) == -1) strerr_die2sys(1, FATAL, "error writing to buffer: ")

static const char *help = USAGE "\n\n\
  -h   display this help\n\
  -z   terminate lines with null instead of newline";

  int
main(int argc, const char **argv)
{
  char eol, opt;
  const char *value;

  eol = '\n';
  while ((opt = option_next(argc, argv, "hz")) != -1) {
    switch (opt) {
      case 'h':
        strerr_die1x(0, help);
      case 'z':
        eol = 0;
        break;
      case '?':
        strerr_die4x(1, FATAL, "unknown option '", &option_error, "'");
    }
  }
  argc -= option_index;
  argv += option_index;

  if (!argc) while (*environ) {
    safe_buffer_puts(buffer_1, *environ);
    safe_buffer_putc(buffer_1, eol);
    ++environ;
  } else while (*argv) {
    if ((value = env_get(*argv))) {
      safe_buffer_puts(buffer_1, value);
      safe_buffer_putc(buffer_1, eol);
    }
    ++argv;
  }
  safe_buffer_flush(buffer_1);
  _exit(0);
}
