#include <stdio.h>
#include <dlfcn.h>

int main()
{
    char op[6];
    int a, b;

    while (scanf("%5s %d %d", op, &a, &b) == 3)
    {
        char libname[14]; // ./libop.so : 5 + 5 + 3 + 1
        snprintf(libname, sizeof(libname), "./lib%s.so", op);

        void *handle = dlopen(libname, RTLD_NOW);
        if (!handle)
        {
            fprintf(stderr, "dlopen failed: %s\n", dlerror());
            continue;
        }

        dlerror(); // clear old error
        int (*fn)(int, int) = (int (*)(int, int)) dlsym(handle, op);

        char *err = dlerror();
        if (err) {
            fprintf(stderr, "dlsym failed: %s\n", err);
            dlclose(handle);
            continue;
        }

        int ans = fn(a, b);
        printf("%d\n", ans);

        dlclose(handle);
    }
    return 0;
}