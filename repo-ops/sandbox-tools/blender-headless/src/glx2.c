typedef void* GLXFBConfig;
void* glXCreateWindow(void*d,void*c,unsigned long w,const int*a){ (void)d;(void)c;(void)w;(void)a; return 0; }
void* glXCreatePixmap(void*d,void*c,unsigned long p,const int*a){ (void)d;(void)c;(void)p;(void)a; return 0; }
void glXDestroyWindow(void*d,unsigned long w){ (void)d;(void)w; }
void glXDestroyPixmap(void*d,unsigned long p){ (void)d;(void)p; }
void* glXCreateNewContext(void*d,void*f,int r,void*s,int x){ (void)d;(void)f;(void)r;(void)s;(void)x; return 0; }
unsigned long glXGetCurrentReadDrawable(void){ return 0; }
void* glXGetFBConfigs(void*d,int s,int*n){ (void)d;(void)s;(void)n; return 0; }
int glXGetFBConfigAttrib(void*d,void*f,int a,int*v){ (void)d;(void)f;(void)a;(void)v; return 0; }
int glXGetWindowAttributes(void*d,unsigned long w,int*a){ (void)d;(void)w;(void)a; return 0; }
void glXQueryDrawable(void*d,unsigned long w,int a,unsigned int*v){ (void)d;(void)w;(void)a;(void)v; }
void glXBindTexImageEXT(void*d,void*p,int b,const int*a){ (void)d;(void)p;(void)b;(void)a; }
void glXReleaseTexImageEXT(void*d,void*p,int b){ (void)d;(void)p;(void)b; }
void glXSwapIntervalEXT(void*d,unsigned long w,int i){ (void)d;(void)w;(void)i; }
const char* glXGetClientString(void*d,int a){ (void)d;(void)a; return ""; }
const char* glXQueryServerString(void*d,int s,int a){ (void)d;(void)s;(void)a; return ""; }
void glXWaitGL(void){ }
void glXWaitX(void){ }
void* glXCreateGLXPixmap(void*d,void*v,unsigned long p){ (void)d;(void)v;(void)p; return 0; }
void glXFreeContextEXT(void*d,void*c){ (void)d;(void)c; }
void glXSelectEvent(void*d,unsigned long w,unsigned long e){ (void)d;(void)w;(void)e; }
void glXGetSelectedEvent(void*d,unsigned long w,unsigned long*e){ (void)d;(void)w;(void)e; }
int glXQueryContext(void*d,void*c,int a,int*v){ (void)d;(void)c;(void)a;(void)v; return 0; }
void* glXGetCurrentReadDrawableSGI(void){ return 0; }
