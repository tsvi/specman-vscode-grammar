// SYNTAX TEST "source.specman" "test_import.e"
sdkfgl

<' 

import foo;
// <----- keyword.control.import.specman
//     ^^^ entity.name.filename.specman
//        ^ punctuation.terminator.specman
import quux, quax;
// <----- keyword.control.import.specman
//     ^^^^  ^^^^ entity.name.filename.specman
//               ^ punctuation.terminator.specman
//         TODO: the comma above should be punctuation.separator.import.specman

'>
