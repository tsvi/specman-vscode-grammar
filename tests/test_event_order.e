// SYNTAX TEST "source.specman" "Event order"

<'

extend sys {
    !flag: bool;
//  ^ punctuation.definition.variable.generation.specman
//   ^^^^ variable.other.member.specman
//       ^ punctuation.separator.type.specman
//         ^^^^ storage.type.specman
//             ^ punctuation.terminator.specman
    
    event e;
//  ^^^^^ storage.type.specman
//        ^ variable.other.member.event.specman
//  FIXME  = punctuation.terminator.specman
    
    on e {
        flag = FALSE;
    };
    
    run() is also {
        flag = TRUE;
        emit e;
        print flag; // prints FALSE
    };
};

'>
