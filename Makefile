assemble:
	nasm -f bin bootloader.asm

run: assemble
	qemu-system-x86_64 -fda bootloader
