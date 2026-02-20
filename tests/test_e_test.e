// SYNTAX TEST "source.specman" "Various (non-compilable) constructs"

<'

export DPI-C verifier.e_impl();
// <- keyword.other.statement.specman
export DPI-C verifier.e_impl();

method_type str2uint_method_t (s: string):uint;
// <- keyword.declaration.specman
//          ^^^^^^^^^^^^^^^^^ entity.name.function.specman
method_type str2uint_method_t (s: string):uint @sys.any;
method_type method_set_sharedlut_entry(u1: uint, u2: uint(bits: 24));
// <- keyword.declaration.specman
//          ^^^^^^^^^^^^^^^^^^^^^^^^^^ entity.name.function.specman
//                                     ^^ variable.parameter.specman
//                                       ^ punctuation.separator.parameter.specman
//                                         ^^^^ storage.type.specman
//                                               ^^ variable.parameter.specman
//                                                 ^ punctuation.separator.parameter.specman
//                                                   ^^^^ storage.type.specman
//                                                       ^^^^^^^^^^ meta.width-modifier.specman
//                                                        ^^^^ keyword.operator.width-modifier.specman


type bla: [BLUE, GREEN, YELLOW](bits: 2);
// <- keyword.declaration.specman
//   ^^^ storage.type.enum.specman
//      ^ punctuation.separator.type.specman
type int_small: uint[0..500](bits: 10);
// <- keyword.declaration.specman

extend sys {
// <- keyword.declaration.class.specman
//     ^^^ entity.name.class.specman

    @import_python(module_name="plot_i", python_name="addVal")
//  ^ punctuation.definition.annotation.specman
//   ^^^^^^^^^^^^^ storage.type.annotation.specman
//                ^                                            punctuation.section.parens.begin.specman
//                 ^^^^^^^^^^^                                 variable.parameter.specman
//                            ^                                keyword.operator.assignment.specman
//                                       ^^^^^^^^^^^           variable.parameter.specman
//                                                  ^          keyword.operator.assignment.specman
    addVal(groupName:string, cycle:int,grade:real) is imported;
//  ^^^^^^ entity.name.function.specman
//         ^^^^^^^^^                                       variable.parameter.specman
//                  ^                                      punctuation.separator.parameter.specman
//                   ^^^^^^                                storage.type.specman
//                                                 ^^      keyword.other.function.specman
//                                                    ^^^^^^^^ keyword.modifier.function.specman

    !l1[20][3] : list of byte;
    l2 : list of uint;

    obj: obj_s is instance;

    final sync_all(trans: cfg_trans)@sys.any is undefined;
//        ^^^^^^^^ entity.name.function.specman
//                 ^^^^^                                     variable.parameter.specman
//                        ^^^^^^^^^                          storage.type.specman
//                                           ^^ keyword.other.function.specman
//                                              ^^^^^^^^^    keyword.modifier.function.specman

    my_e_import(i:int,s:string):int is import DPI-C sv_impl;
//  ^^^^^^^^^^^                                              entity.name.function.specman
//              ^                                            variable.parameter.specman
//                ^^^                                        storage.type.specman
//                    ^                                      variable.parameter.specman
//                      ^^^^^^                               storage.type.specman
//                             ^                             punctuation.separator.return-type.specman
//                              ^^^                          storage.type.specman
//                                  ^^                       keyword.other.function.specman
//                                     ^^^^^^                keyword.other.function.specman
//                                            ^^^^^          keyword.declaration.specman
//                                                  ^^^^^^^ entity.name.function.external.specman

    //fn_multi_line(a: bool,
    //              b: int):bool is empty;


    run() is also {
//  ^^^ entity.name.function.specman
//        ^^ keyword.other.function.specman
        var a: int = 0;
//      ^^^                keyword.declaration.specman
//          ^              variable.other.specman
//           ^             punctuation.separator.type.specman
//             ^^^         storage.type.specman
        var e1: [a,b,c];
//      ^^^              keyword.declaration.specman
//          ^^           variable.other.specman
//            ^          punctuation.separator.type.specman
//              ^        punctuation.brackets.begin.specman
        var e2: [a,b,c](bits: 0b10);
//      ^^^                          keyword.declaration.specman
//          ^^                       variable.other.specman
//            ^                      punctuation.separator.type.specman
//              ^                    punctuation.brackets.begin.specman
//                    ^              punctuation.brackets.end.specman
//                     ^^^^^^^^^^^^  meta.width-modifier.specman
//                      ^^^^         keyword.operator.width-modifier.specman
//                                 ^ punctuation.terminator.specman
        var x: int(bits:4);
//      ^^^                keyword.declaration.specman
//          ^              variable.other.specman
//           ^             punctuation.separator.type.specman
//             ^^^         storage.type.specman
        var y: longuint[0..21 ] (bits: 5);
//      ^^^                               keyword.declaration.specman
//          ^                              variable.other.specman
//           ^                             punctuation.separator.type.specman
//             ^^^^^^^^                    storage.type.specman
        out(b.l1.apply(it > 0x7f ? 1 : 0));
//      ^^^                                 support.function.builtin.specman
//               ^^^^^                     support.function.builtin.specman
//                     ^^                   variable.language.specman
//                          ^^^^            constant.numeric.unsized.hex.specman
        var s: string := l1.apply(it > 127 ? 1'b1 : 1'b0);
//      ^^^                                                 keyword.declaration.specman
//          ^                                               variable.other.specman
//           ^                                              punctuation.separator.type.specman
//             ^^^^^^                                       storage.type.specman
//                    ^^                                    keyword.operator.assignment.specman
//                          ^^^^^                           support.function.builtin.specman
//                                ^^                        variable.language.specman

        var matrix: list of list of int = {{1;2;3};{4;5;6}};
//      ^^^                                                  keyword.declaration.specman
//          ^^^^^^                                           variable.other.specman
//                ^                                          punctuation.separator.type.specman
//                  ^^^^^^^                                  storage.modifier.specman
//                          ^^^^^^^                          storage.modifier.specman
//                                  ^^^                      storage.type.specman
        var matix_3d: list of list of list of int = {matrix;{6;7;8};{9;10;11}};
//      ^^^                                                                     keyword.declaration.specman
//          ^^^^^^^^                                                            variable.other.specman
//                  ^                                                           punctuation.separator.type.specman
//                    ^^^^^^^                                                   storage.modifier.specman
//                            ^^^^^^^                                           storage.modifier.specman
//                                    ^^^^^^^                                   storage.modifier.specman
//                                            ^^^                               storage.type.specman

        var cl: list of list(key: it) of uint(bits: 4);
//      ^^^                                             keyword.declaration.specman
//          ^^                                          variable.other.specman
//            ^                                         punctuation.separator.type.specman
//              ^^^^^^^                                 storage.modifier.specman
//                                       ^^^^          storage.type.specman

        assert a==0;
//      ^^^^^^       support.function.builtin.specman
        first of {
            start foo(a+b);
        };

        all of {
        		{ first_tcm(); };
        		{ second_tcm(); };
        };

        do sequence keeping { it == seq };

        var l: list of int = {1;2;7;4}.sort();
        l = l.reverse();

        for each (elem) using index (idx) in l {
          print elem, idx;
        };

        bar();
//      ^^^                                                  variable.function.specman
//         ^                                                 punctuation.section.parens.begin.specman
//          ^                                                punctuation.section.parens.end.specman
        compute foo();

        print {3;4;5}.min(it);
        outf("built-in function");
//      ^^^^                                                 support.function.builtin.specman

        q = get_info(bar).member_function();

        if p is a BLUE color_s (blue) {
          print p;
        };

        p = new;
        p = new with { it.enable };
        p = new colors_s;

        if p is a GREEN color_s (green) {
          type bla is a parent;
          print p;
        };

        keep type p is a child;
        msg = appendf("%s] triggered by %s", msg, str_join(source_events.apply(.to_string()), " and "));
    };

    l: list(key: string) of uint;
    ll: list of list(key: it) of uint(bits: 4);
    const member1: uint(bits:23);
//  ^^^^^ storage.modifier.const.specman
//        ^^^^^^^ variable.other.member.specman
    member2: list of list of my_struct_s;

    final sync_all (trans: cfg_trans, a: uint[0..7], b: bool = TRUE)@sys.any is only {
      if (ls.size() > 2) {
         var pix: fme_video_rgb_s = new;
         var r8 : uint = ls[0].as_a(uint);
         var g8 : uint = ls[1].as_a(uint);
         pix.r = r8.as_a(uint (bits:8));
         pix.g = g8.as_a(uint (bits:8));
         img.data.add(pix);
      } else {
          message(NONE, "Error: Cannot read color data.");
          break;
      };

      start multi_line_method_params(get_a(a), b);
      assert (add == foo(x));
    };

    walk_objections(unt: any_unit, obj_kind: objection_kind) is {
      if unt.get_objection_counter(obj_kind) > 0 {
         outf("Still pending objections in unit %s: %d\n", unt, unt.get_objection_counter(obj_kind));
      };
      for each (u) in unt.get_objection_list(obj_kind) {
         walk_objections(u, obj_kind);
      };
      for each (v) in x.bla_list {
        a.quit();
      }
   };



   has_restriction(range: address_range_s,
                   restr: access_restriction_t,
                   master_name: bus_interface_names_t = UNDEFINED): bool is {
      if intersect_range(range) {
         result = (restrictions.has(it == restr) and (bus_interface_names.is_empty() or master_name == UNDEFINED or bus_interface_names.has(it == master_name))) ? TRUE : FALSE;
      };
   };



};

extend bla: [BLACK];
// <- keyword.declaration.specman
'>
