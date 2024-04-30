program rover;

uses sysutils, rvm_def;
  

function init_machine: rvm;
var
    i, j, k: Integer;
    our_machine: rvm;  
begin
    for i := 0 to MAX_GENERAL_REGS do
    begin
        New(our_machine.g_register[i]); // Use i instead of j
        our_machine.g_register[i]^.value.obj_type := RVM_TYPE_NULL;
        our_machine.g_register[i]^.value.obj_value := 0;
        our_machine.g_register[i]^.value.obj_flag := ' ';
    end;

    for j := 0 to MAX_MEMORY_STACK do
    begin
        New(our_machine.memory_stack[j]);  
        for k := 0 to MAX_STACK_ELEMENTS do
        begin
            our_machine.memory_stack[j]^.value[k].obj_type := RVM_TYPE_NULL;
            our_machine.memory_stack[j]^.value[k].obj_value := 0;
            our_machine.memory_stack[j]^.value[k].obj_flag := ' ';
        end;
    end;
    init_machine := our_machine;
end;


procedure rvm_run(our_code: array of rvm_input; our_machine: rvm);
var
    i, j: Integer; 
begin
    i := -1;
    while i < MAX_CODE_SIZE do
    begin
        Inc(i);
        if our_code[i].i_type = INSTRUCTION then
        begin
            if our_code[i].i_instr = LD then
            begin
                our_machine.current_rpos := our_code[i + 2].i_ref.r_reg;
                if our_code[i + 1].i_type = VALUE then
                begin
                    our_machine.g_register[our_machine.current_rpos]^.value := our_code[i + 1].i_value;

                    writeln('Loading ' + IntToStr(our_machine.g_register[our_machine.current_rpos]^.value.obj_value) +
                        ' Into ' + IntToStr(our_machine.current_rpos));
                end;
            end
            else if our_code[i].i_instr = ST then
            begin
                our_machine.current_mpos := our_code[i + 2].i_ref.r_mem;
                if our_code[i + 1].i_type = REFERENTIAL then
                begin
                    our_machine.memory_stack[our_machine.current_mpos]^.value[0] := our_machine.g_register[our_machine.current_rpos]^.value;
                    writeln('Storing ' + IntToStr(our_machine.memory_stack[our_machine.current_mpos]^.value[0].obj_value) +
                            ' Into Memory Stack #' + IntToStr(our_machine.current_mpos));
                end;
            end
            else if our_code[i].i_instr = PR then
            begin
                writeln('>>>>>>>>PRINTING STACK #' + IntToStr(Integer(our_code[i + 1].i_ref.r_mem)));
                for j := 0 to MAX_STACK_ELEMENTS do
                begin
                    writeln('#' + IntToStr(j) + ' Type: ' + IntToStr(Integer(our_machine.memory_stack[our_code[i + 1].i_ref.r_mem]^.value[j].obj_type)) +
                                                ' Val: ' + IntToStr(our_machine.memory_stack[our_code[i + 1].i_ref.r_mem]^.value[j].obj_value));
                end;
            end;
        end;
    end;
end;

var
    our_machine: rvm;
    our_code: array[0..MAX_CODE_SIZE] of rvm_input;
begin
    our_machine := init_machine;

    our_code[0].i_type := INSTRUCTION;
    our_code[0].i_instr := LD;
    our_code[1].i_type := VALUE;
    our_code[1].i_value.obj_type := RVM_TYPE_NUMBER;
    our_code[1].i_value.obj_value := 17;

    our_code[2].i_type := REFERENTIAL;
    our_code[2].i_ref.r_reg := 1;

    our_code[3].i_type := INSTRUCTION;
    our_code[3].i_instr := ST;
    our_code[4].i_type := REFERENTIAL;
    our_code[4].i_ref.r_mem := 0;

    our_code[5].i_type := INSTRUCTION;
    our_code[5].i_instr := PR;

    our_code[6].i_type := REFERENTIAL;
    our_code[6].i_ref.r_mem := 0;

    rvm_run(our_code, our_machine);
end.
