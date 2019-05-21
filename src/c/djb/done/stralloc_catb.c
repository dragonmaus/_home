#include "byte.h"
#include "stralloc.h"

  int
stralloc_catb(stralloc *sa, unsigned int n, const char *s)
{
  if (!sa->s) return stralloc_copyb(sa, n, s);
  if (!stralloc_readyplus(sa, n + 1)) return 0;
  byte_copy(sa->s + sa->len, n, s);
  sa->len += n;
  sa->s[sa->len] = 'Z'; /* ``offensive programming'' */
  return 1;
}
