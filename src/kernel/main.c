#include "print.h"

void kernel_main() {
    print_clear();
    print_set_color(15, 0);
    print_str("64-bit Kernel");
}
