typedef void* (*GLXProc)(const char*);
void* glXGetProcAddress(const char* n){ (void)n; return 0; }
void* glXGetProcAddressARB(const char* n){ (void)n; return 0; }
int glXQueryExtension(void*d,int*a,int*b){ (void)d;(void)a;(void)b; return 0; }
int glXQueryVersion(void*d,int*a,int*b){ (void)d;(void)a;(void)b; return 0; }
void* glXChooseVisual(void*d,int*s,int*a){ (void)d;(void)s;(void)a; return 0; }
void* glXCreateContext(void*d,void*v,void*s,int f){ (void)d;(void)v;(void)s;(void)f; return 0; }
int glXMakeCurrent(void*d,unsigned long dr,void*c){ (void)d;(void)dr;(void)c; return 0; }
void glXSwapBuffers(void*d,unsigned long dr){ (void)d;(void)dr; }
void* glXGetCurrentContext(void){ return 0; }
void* glXGetCurrentDisplay(void){ return 0; }
unsigned long glXGetCurrentDrawable(void){ return 0; }
const char* glXQueryExtensionsString(void*d,int s){ (void)d;(void)s; return ""; }
int glXGetConfig(void*d,void*v,int a,int*o){ (void)d;(void)v;(void)a;(void)o; return 0; }
int glXIsDirect(void*d,void*c){ (void)d;(void)c; return 0; }
void glXDestroyContext(void*d,void*c){ (void)d;(void)c; }
int glXMakeContextCurrent(void*d,unsigned long a,unsigned long b,void*c){ (void)d;(void)a;(void)b;(void)c; return 0; }
void* glXChooseFBConfig(void*d,int s,const int*a,int*n){ (void)d;(void)s;(void)a;(void)n; return 0; }
void* glXGetVisualFromFBConfig(void*d,void*c){ (void)d;(void)c; return 0; }
