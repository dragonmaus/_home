#include "env.h"

  extern const char *
env_findeq(const char *s)
{
  for (; *s; ++s) if (*s == '=') return s;
  return 0;
}
