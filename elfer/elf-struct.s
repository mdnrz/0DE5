# --------------------- CONSTANTS ------------------------- #

    #---------- ELF header ------------ #
.set elf_header_size, 0x40
    .set eh_idx_ident, 0x0
    .set eh_idx_type, 0x10
    .set eh_idx_machine, 0x12
    .set eh_idx_version, 0x14
    .set eh_idx_entry, 0x18
    .set eh_idx_phoff, 0x20
    .set eh_idx_shoff, 0x28
    .set eh_idx_flags, 0x30
    .set eh_idx_ehsize, 0x34
    .set eh_idx_phentsize, 0x36
    .set eh_idx_phnum, 0x38
    .set eh_idx_shentsize, 0x3A
    .set eh_idx_shnum, 0x3C
    .set eh_idx_shstrndx, 0x3E

.set eh_idnet_size, 0x10
    .set ei_idx_mag0, 0x0
        .set ei_val_mag0, 0x7F
    .set ei_idx_mag1, 0x1
        .set ei_val_mag1, 'E'
    .set ei_idx_mag2, 0x2
        .set ei_val_mag2, 'L'
    .set ei_idx_mag3, 0x3
        .set ei_val_mag3, 'F'
    .set ei_idx_class, 0x4
        .set ei_val_class_none, 0x0
        .set ei_val_class_32, 0x1
        .set ei_val_class_64, 0x2
    .set ei_idx_data, 0x5
        .set ei_val_data_none, 0x0
        .set ei_val_data_lsb, 0x1 # little endian
        .set ei_val_data_msb, 0x2 # big endian
    .set ei_idx_version, 0x6

.set eh_type_size, 0x2
    .set et_val_none, 0x0
    .set et_val_rel, 0x1
    .set et_val_exec, 0x2
    .set et_val_dyn, 0x3
    .set et_val_core, 0x4
    .set et_val_loproc, 0xFF00
    .set et_val_hiproc, 0xFFFF

.set eh_machine_size, 0x2
    .set em_val_none, 0x0
    .set em_val_m32, 0x1
    .set em_val_sparc, 0x2
    .set em_val_386, 0x3
    .set em_val_68k, 0x4
    .set em_val_88k, 0x5
    .set em_val_860, 0x7
    .set em_val_mips, 0x8
    .set em_val_mips_rs4_be, 0xA
    .set em_val_x8664, 0x3E

.set eh_version_size, 0x4
    .set ev_val_none, 0x0
    .set ev_val_current, 0x1

.set eh_entry_size, 0x8
.set eh_phoff_size, 0x8
.set eh_shoff_size, 0x8
.set eh_flags_size, 0x4
.set eh_ehsize_size, 0x2
.set eh_phentsize_size, 0x2
.set eh_phnum_size, 0x2
.set eh_shentsize_size, 0x2
.set eh_shnum_size, 0x2
.set eh_shstrndx_size, 0x2

.set ei_mag0_idx, 0x0
.set ei_mag1_idx, 0x1
.set ei_mag2_idx, 0x2
.set ei_mag3_idx, 0x3
.set ei_class_idx, 0x4
.set ei_data_idx, 0x5
.set ei_version_idx, 0x6

    #---------- Program header ------------ #
.set p_header_size, 0x38
    .set ph_idx_type, 0x0
        .set pt_val_null, 0x0
        .set pt_val_load, 0x1
        .set pt_val_dynamic, 0x2
        .set pt_val_interp, 0x3
        .set pt_val_note, 0x4
        .set pt_val_shlib, 0x5
        .set pt_val_phdr, 0x6
        .set pt_val_loproc, 0x70000000
        .set pt_val_hiproc, 0x7fffffff
    .set ph_idx_flags, 0x4
    .set ph_idx_offset, 0x8
    .set ph_idx_vaddr, 0x10
    .set ph_idx_paddr, 0x18
    .set ph_idx_filesz, 0x20
    .set ph_idx_memsz, 0x28
    .set ph_idx_align, 0x30

.data
.bss
elf_header:
    .space elf_header_size
program_header:
    .space p_header_size

