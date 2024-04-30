unit rvm_def;

interface 

const
    MAX_GENERAL_REGS = 1;
    MAX_CODE_SIZE = 6;
    MAX_MEMORY_STACK = 2;
    MAX_STACK_ELEMENTS = 8;

type
    
    rvm_types = (
        RVM_TYPE_NULL,
        RVM_TYPE_NUMBER,
        RVM_TYPE_BOOL
    );

    rvm_instr_set = (
        LD, // LoaD
        ST, // STore
        CL, // CalL procedure
        LB, // LaBel procedure
        PR, // PRint stack
        SUM // SUM up 
    );

    rvm_i_types = (
        INSTRUCTION,
        VALUE,
        REFERENTIAL
    );
    rvm_obj = record
        obj_type: rvm_types;
        obj_value: Word;
        obj_flag: Char;
    end;

    rvm_ref = record
        r_reg: ShortInt;
        r_mem: ShortInt;
    end;

    rvm_input = record
        i_type: rvm_i_types;
        i_instr: rvm_instr_set;
        i_value: rvm_obj;
        i_ref: rvm_ref;
    end;

    rvm_reg = record
        value: rvm_obj;
    end;

    rvm_mem = record
        value: Array[0..MAX_STACK_ELEMENTS] of rvm_obj;
    end;

    rvm_mem_ptr = ^rvm_mem;

    rvm_reg_ptr = ^rvm_reg;

    rvm = record
        current_rpos: ShortInt;
        current_mpos: ShortInt;
        g_register: Array[0..MAX_GENERAL_REGS] of rvm_reg_ptr;
        memory_stack: Array[0..MAX_MEMORY_STACK] of rvm_mem_ptr;
    end;
    
implementation

end.
