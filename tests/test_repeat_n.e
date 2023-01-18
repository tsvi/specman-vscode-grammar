// SYNTAX TEST "source.specman" "test_repeat_n.e"
<'

define <repeat_n'statement> "repeat(<exp>) <block>" as {
    for i<?> from 0 to ((<exp>)-1) {
        <block>
    };
};


'>
