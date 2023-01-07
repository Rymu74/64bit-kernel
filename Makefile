kernel_source_files := $(shell find src/kernel -name *.c)
kernel_object_files := $(patsubst src/kernel/%.c, build/kernel/%.o, $(kernel_source_files))

x86_64_c_source_files := $(shell find lib/ -name *.c)
x86_64_c_object_files := $(patsubst lib/%.c, build/%.o, $(x86_64_c_source_files))

x86_64_asm_source_files := $(shell find src/boot -name *.asm)
x86_64_asm_object_files := $(patsubst src/boot/%.asm, build/%.o, $(x86_64_asm_source_files))

x86_64_object_files := $(x86_64_c_object_files) $(x86_64_asm_object_files)

$(kernel_object_files): build/kernel/%.o : src/kernel/%.c
	mkdir -p $(dir $@) && \
	gcc -c -I include/ -ffreestanding $(patsubst build/kernel/%.o, src/kernel/%.c, $@) -o $@

$(x86_64_c_object_files): build/%.o : lib/%.c
	mkdir -p $(dir $@) && \
	gcc -c -I include/ -ffreestanding $(patsubst build/%.o, lib/%.c, $@) -o $@

$(x86_64_asm_object_files): build/%.o : src/boot/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/%.o, src/boot/%.asm, $@) -o $@

.PHONY: iso
iso: $(kernel_object_files) $(x86_64_object_files)
	mkdir -p dist/x86_64 && \
	ld -n -o dist/x86_64/kernel.bin -T targets/linker.ld $(kernel_object_files) $(x86_64_object_files) && \
	cp dist/x86_64/kernel.bin targets/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o kernel.iso targets/
