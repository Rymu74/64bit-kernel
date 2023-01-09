#include "print.h"

void kernel_main() {
    print_clear();
    print_set_color(15, 0);
    printf("64-bit Kernel");
}
