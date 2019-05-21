#ifndef PATH_H
#define PATH_H

extern int         path_absolute(char *, int);
extern const char *path_base(const char *);
extern int         path_canonical(char *, int);
#ifdef WIN32
extern int         path_fix(char *);
#endif

#endif
