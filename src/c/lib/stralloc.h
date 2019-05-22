#ifndef STRALLOC_H
#define STRALLOC_H

#include "gen_alloc.h"

GEN_ALLOC_typedef(stralloc, char, s, len, a)

extern int stralloc_ready(stralloc *, unsigned int);
extern int stralloc_readyplus(stralloc *, unsigned int);

extern int stralloc_copy(stralloc *, const stralloc *);
extern int stralloc_cat(stralloc *, const stralloc *);

extern int stralloc_copys(stralloc *, const char *);
extern int stralloc_cats(stralloc *, const char *);

extern int stralloc_copyb(stralloc *, unsigned int, const char *);
extern int stralloc_catb(stralloc *, unsigned int, const char *);

extern int stralloc_append(stralloc *, const char *); /* beware: this takes a pointer to 1 char */
extern int stralloc_starts(const stralloc *, const char *);

extern int stralloc_catulong0(stralloc *, unsigned int, unsigned long);
extern int stralloc_catlong0(stralloc *, unsigned int, long);

#define stralloc_0(sa) stralloc_append(sa, "")

#define stralloc_catlong(sa,l) stralloc_catlong0((sa), 0, (l))
#define stralloc_catuint0(sa,n,i) stralloc_catulong0((sa), (n), (i))
#define stralloc_catint0(sa,n,i) stralloc_catlong0((sa), (n), (i))
#define stralloc_catint(sa,i) stralloc_catlong0((sa), 0, (i))

#endif
