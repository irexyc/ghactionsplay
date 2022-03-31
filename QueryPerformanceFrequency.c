#include <windows.h>
#include <stdio.h>
int main() {
    LARGE_INTEGER perf_frequency;
    BOOL ret = QueryPerformanceFrequency(&perf_frequency);
    printf("qpf: ret %d, freq %zu\n", ret, perf_frequency.QuadPart);
    return 0;
}
