#ifndef SYS_H
#define SYS_H

struct dirent {
	unsigned long int  d_ino;
	unsigned long int  d_off;
	unsigned short int d_reclen;
	char               d_name[256];
	char               d_type;
};

struct dirent64 {
	unsigned long int  d_ino;
	unsigned long int  d_off;
	unsigned short int d_reclen;
	unsigned char      d_type;
	char               d_name[256];
};

struct timeval {
	long int tv_sec;
	long int tv_usec;
};

struct rusage {
	struct timeval ru_utime;
	struct timeval ru_stime;
	long int       ru_maxrss;
	long int       ru_ixrss;
	long int       ru_idrss;
	long int       ru_isrss;
	long int       ru_minflt;
	long int       ru_majflt;
	long int       ru_nswap;
	long int       ru_inblock;
	long int       ru_oublock;
	long int       ru_msgsnd;
	long int       ru_msgrcv;
	long int       ru_nsignals;
	long int       ru_nvcsw;
	long int       ru_nivcsw;
};

struct timespec {
	long int tv_sec;
	long int tv_nsec;
};

struct stat {
	unsigned long int  st_dev;
	unsigned long int  st_ino;
	unsigned long int  st_nlink;
	unsigned int       st_mode;
	unsigned int       st_uid;
	unsigned int       st_gid;
	unsigned int       __pad0;
	unsigned long int  st_rdev;
	long int           st_size;
	long int           st_blksize;
	long int           st_blocks;
	struct timespec    st_atim;
	struct timespec    st_mtim;
	struct timespec    st_ctim;
	long int           __unused[3];
};

extern long int     read(int fd, char *buf, unsigned long int nbyte);
extern long int     write(int fd, const char *buf, unsigned long int nbyte);
extern int          open(const char *path, int flags, int mode);
extern int          close(int fd);
extern int          stat(const char *path, struct stat *sb);
extern int          fstat(int fd, struct stat *sb);
extern int          lstat(const char *path, struct stat *sb);
extern int          brk(const char *addr);
extern int          sbrk(int incr);
extern int          fork(void);
extern int          execve(const char *fname, char **argv, char **envv);
extern void         exit(int rval);
extern int          wait3(int *status, int options, struct rusage *rusage);
extern int          wait4(int pid, int *status, int options, struct rusage *rusage);
extern int          waitpid(int pid, int *status, int options);
extern int          fcntl(int fd, int cmd, long int arg);
extern int          fsync(int fd);
extern int          getdents(int fd, struct dirent *dirp, unsigned int count);
extern int          getcwd(char *buf, unsigned int buflen);
extern int          chdir(const char *path);
extern long int     readlink(const char *path, char *buf, unsigned long int count);
extern long int     time(long int *t);
extern int          getdents64(unsigned int fd, struct dirent64 *dirp, unsigned long int count);
extern int          clock_gettime(int clock_id, struct timespec *tp);

#define DT_UNKNOWN         000
#define DT_FIFO            001
#define DT_CHR             002
#define DT_DIR             004
#define DT_BLK             006
#define DT_REG             010
#define DT_LNK             012
#define DT_SOCK            014
#define DT_WHT             016

#define F_DUPFD            00000
#define F_DUPFD_CLOEXEC    02006
#define F_GETFD            00001
#define F_SETFD            00002
#define F_GETFL            00003
#define F_SETFL            00004
#define F_GETLK            00005
#define F_SETLK            00006
#define F_SETLKW           00007
#define F_RDLCK            00000
#define F_WRLCK            00001
#define F_UNLCK            00002
#define F_OFD_GETLK        00044
#define F_OFD_SETLK        00045
#define F_OFD_SETLKW       00046
#define F_GETOWN           00011
#define F_SETOWN           00010
#define F_GETOWN_EX        00020
#define F_SETOWN_EX        00017
#define F_OWNER_TID        00000
#define F_OWNER_PID        00001
#define F_OWNER_PGRP       00002
#define F_GETSIG           00013
#define F_SETSIG           00012
#define F_SETLEASE         02000
#define F_GETLEASE         02001
#define F_NOTIFY           02002
#define F_SETPIPE_SZ       02007
#define F_GETPIPE_SZ       02010
#define F_ADD_SEALS        02011
#define F_SEAL_SEAL        00001
#define F_GET_SEALS        02012
#define F_SEAL_SHRINK      00002
#define F_SEAL_GROW        00004
#define F_SEAL_WRITE       00010
#define F_GET_RW_HINT      02013
#define F_SET_RW_HINT      02014
#define F_GET_FILE_RW_HINT 02015
#define F_SET_FILE_RW_HINT 02016
#define F_GETLK64          F_GETLK
#define F_SETLK64          F_SETLK
#define F_SETLKW64         F_SETLKW

#define O_RDONLY           000000000
#define O_WRONLY           000000001
#define O_CREAT            000000100
#define O_EXCL             000000200
#define O_NOCTTY           000000400
#define O_TRUNC            000001000
#define O_APPEND           000002000
#define O_NONBLOCK         000004000
#define O_DSYNC            000010000
#define O_ASYNC            000020000
#define O_DIRECTORY        000200000
#define O_NOFOLLOW         000400000
#define O_CLOEXEC          002000000
#define O_SYNC             004010000
#define O_PATH             010000000

#define S_IFIFO            0010000
#define S_IFCHR            0020000
#define S_IFDIR            0040000
#define S_IFBLK            0060000
#define S_IFREG            0100000
#define S_IFLNK            0120000
#define S_IFSOCK           0140000
#define S_IFMT             0170000

#define S_ISFIFO(mode)     (((mode) & S_IFMT) == S_IFIFO)
#define S_ISCHR(mode)      (((mode) & S_IFMT) == S_IFCHR)
#define S_ISDIR(mode)      (((mode) & S_IFMT) == S_IFDIR)
#define S_ISBLK(mode)      (((mode) & S_IFMT) == S_IFBLK)
#define S_ISREG(mode)      (((mode) & S_IFMT) == S_IFREG)
#define S_ISLNK(mode)      (((mode) & S_IFMT) == S_IFLNK)
#define S_ISSOCK(mode)     (((mode) & S_IFMT) == S_IFSOCK)

#define S_IXOTH            00001
#define S_IWOTH            00002
#define S_IROTH            00004
#define S_IRWXO            00007
#define S_IXGRP            00010
#define S_IWGRP            00020
#define S_IRGRP            00040
#define S_IRWXG            00070
#define S_IXUSR            00100
#define S_IWUSR            00200
#define S_IRUSR            00400
#define S_IRWXU            00700
#define S_ISVTX            01000
#define S_ISGID            02000
#define S_ISUID            04000

#define UTIME_OMIT         0x3FFFFFFE
#define UTIME_NOW          0x3FFFFFFF

#define WEXITSTATUS(s)     (((s) & 0xFF00) >> 8)
#define WTERMSIG(s)        ((s) & 0x7F)
#define WSTOPSIG(s)        WEXITSTATUS(s)
#define WCOREDUMP(s)       ((s) & 0x80)
#define WIFEXITED(s)       (!WTERMSIG(s))
#define WIFSTOPPED(s)      ((short)((((s) & 0xFFFF) * 0x10001) >> 8) > 0x7F00)
#define WIFSIGNALED(s)     (((s) & 0xFFFF) - 1U < 0xFFU)
#define WIFCONTINUED(s)    ((s) == 0xFFFF)

#endif
