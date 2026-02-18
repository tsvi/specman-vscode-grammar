// SYNTAX TEST "source.specman" "test_templates_and_units.e"

<'

-- ==========================================================================
-- Package declaration
-- ==========================================================================

package singleagent;
// <------ entity.name.namespace.specman
//      ^^^^^^^^^^^ entity.name.specman
//                 ^ punctuation.terminator.specman

-- ==========================================================================
-- 3.2.1. Defining Structs
-- Syntax: struct struct-type [like base-struct-type]
--     [implementing interface-name, ...] { [struct-member;...] }
-- ==========================================================================

-- Struct implementing multiple interfaces
-- Reference: struct s1 implementing A, B { ... };
struct uses_foo_s implementing foo_if, third_if {
// ^^^ keyword.declaration.class.specman
//     ^^^^^^^^^^ entity.name.class.specman
//                ^^^^^^^^^^^^ keyword.declaration.interface.specman
//                             ^^^^^^ storage.type.interface.specman
//                                              ^ punctuation.section.class.begin.specman
};

-- Struct with like inheritance
-- Reference: struct cell_8023 like cell {};
struct data_item_s like base_data_item_s {
// ^^^ keyword.declaration.class.specman
//     ^^^^^^^^^^^ entity.name.class.specman
//                 ^^^^ keyword.declaration.like.specman
//                      ^^^^^^^^^^^^^^^^ entity.other.inherited-class.specman
//                                       ^ punctuation.section.class.begin.specman
};

-- Struct with like and implementing
-- Reference: struct struct-type [like base] [implementing interface,...] { ... }
struct full_s like base_s implementing intf_a, intf_b {
// ^^^ keyword.declaration.class.specman
//     ^^^^^^ entity.name.class.specman
//            ^^^^ keyword.declaration.like.specman
//                 ^^^^^^ entity.other.inherited-class.specman
//                        ^^^^^^^^^^^^ keyword.declaration.interface.specman
//                                     ^^^^^^ storage.type.interface.specman
//                                                    ^ punctuation.section.class.begin.specman
};

-- Empty struct
struct empty_s {};

-- ==========================================================================
-- 3.3.1. extend struct-type
-- Syntax: extend [struct-subtype] base-struct-type
--     [implementing interface-name, ...] { [struct-member;...] }
-- ==========================================================================

-- Extend sys
extend sys {
// <-- keyword.declaration.class.specman
//     ^^^ entity.name.class.specman
//         ^ punctuation.section.class.begin.specman
   run() is also {
      print me;
   };
};

-- Extend with implementing
-- Reference: extend base-struct-type [implementing interface,...] { ... }
extend data_item_s implementing serializable_if {
// <-- keyword.declaration.class.specman
//     ^^^^^^^^^^^ entity.name.class.specman
};

-- ==========================================================================
-- 3.11. Defining Interface Types
-- Syntax: interface interface-name [like base-interface-name, ...]
--     { [interface-member;...] }
-- ==========================================================================

-- Package interface with multiple base interfaces
-- Reference: interface A like B { ... };
package interface foo_if like base_if, advanced_if {
// <------ entity.name.namespace.specman
//      ^^^^^^^^^ keyword.declaration.interface.specman
//                ^^^^^^ entity.name.interface.specman
//                       ^^^^ keyword.declaration.like.specman
//                            ^^^^^^^ storage.type.interface.specman
};

-- Simple interface without like
-- Reference: interface A { ... };
interface simple_if {
// <------- keyword.declaration.interface.specman
//        ^^^^^^^^^ entity.name.interface.specman
};

-- Interface with multiple base interfaces
-- Reference: interface name like base1, base2 { ... };
interface multi_if like base_if_a, base_if_b {
// <------- keyword.declaration.interface.specman
//        ^^^^^^^^ entity.name.interface.specman
//                 ^^^^ keyword.declaration.like.specman
//                      ^^^^^^^^^ storage.type.interface.specman
};

-- ==========================================================================
-- 4.2.1. Defining Units
-- Syntax: unit unit-type [like base-unit-type] { [unit-member;...] }
-- ==========================================================================

-- Simple unit with like inheritance
-- Reference: unit XYZ_channel { ... };
unit singleagent_flat_env_u like imc_base_env_u {
// ^ keyword.declaration.class.specman
//   ^^^^^^^^^^^^^^^^^^^^^^ entity.name.class.specman
//                          ^^^^ keyword.declaration.like.specman
//                               ^^^^^^^^^^^^^^ entity.other.inherited-class.specman
//                                              ^ punctuation.section.class.begin.specman
   static kind: env_kind_t = FLAT;
// ^^^^^^ storage.modifier.static.specman
   keep config.env_name == name;
};

-- Unit with unit instance fields (4.2.2)
-- Reference: field-name [: unit-type] is instance
unit singleagent_env_u like singleagent_flat_env_u {
// ^ keyword.declaration.class.specman
//   ^^^^^^^^^^^^^^^^^ entity.name.class.specman
//                     ^^^^ keyword.declaration.like.specman
//                          ^^^^^^^^^^^^^^^^^^^^^^ entity.other.inherited-class.specman
//                                                 ^ punctuation.section.class.begin.specman

   agent: agent default singleagent_agent_u is instance;
// ^^^^^ variable.other.member.specman
//      ^ punctuation.separator.type.specman
//                                             ^^^^^^^^ storage.modifier.specman
//                                                     ^ punctuation.terminator.specman
   keep agent.env_name == read_only(me.name);
// ^^^^ keyword.other.constraint.specman
//                     ^^ keyword.operator.comparison.specman
   keep soft agent.active_passive == ACTIVE;
// ^^^^ keyword.other.constraint.specman
//      ^^^^ keyword.modifier.constraint.specman
//                                ^^ keyword.operator.comparison.specman

   connect_pointers() is also {
// ^^^^^^^^^^^^^^^^ entity.name.function.specman
      agent.env_p = me;
//                ^ keyword.operator.assignment.specman
//                  ^^ variable.language.specman
      if me::kind == FLAT {
//    ^^ keyword.conditional.specman
//       ^^ variable.language.specman
//                ^^ keyword.operator.comparison.specman
         print me;
//       ^^^^^ support.function.builtin.specman
//             ^^ variable.language.specman
      };
   };
};

-- Unit with like and implementing (combined)
-- Reference: unit unit-type [like base] [implementing if,...] { ... }
unit port_map_u like base_port_map_u implementing advance_if {
// ^ keyword.declaration.class.specman
//   ^^^^^^^^^^ entity.name.class.specman
//              ^^^^ keyword.declaration.like.specman
//                   ^^^^^^^^^^^^^^^ entity.other.inherited-class.specman
//                                   ^^^^^^^^^^^^ keyword.declaration.interface.specman
//                                                ^^^^^^^^^^ storage.type.interface.specman
//                                                           ^ punctuation.section.class.begin.specman
};

-- Unit with implementing only (no like)
-- Reference: unit unit-type [implementing if,...] { ... }
unit driver_u implementing driver_if {
// ^ keyword.declaration.class.specman
//   ^^^^^^^^ entity.name.class.specman
//            ^^^^^^^^^^^^ keyword.declaration.interface.specman
//                         ^^^^^^^^^ storage.type.interface.specman
//                                   ^ punctuation.section.class.begin.specman
};

-- Unit derived from template instance with like (5.3 instantiation as base)
-- Reference: unit name like template-name of (actual-params) { ... }
unit singleagent_monitor_u like imc_base_monitor_u of (singleagent_data_item_s) {
// ^ keyword.declaration.class.specman
//   ^^^^^^^^^^^^^^^^^^^^^ entity.name.class.specman
//                         ^^^^ keyword.declaration.like.specman

   -- 4.2.3. field: unit-type (unit pointer, not instance)
   !agent_p: singleagent_agent_u;
   !pmp_p  : singleagent_port_map_u;

   -- Events
   event clk_unqualified_e is only @pmp_p.clock_rise_e;
   event clk_e             is only {not true(pmp_p.reset_active())}@clk_unqualified_e;

   event reset_start_e is only @agent_p.pmp.reset_async_start_e;
   event reset_end_e   is only @agent_p.pmp.reset_async_end_e;

   on reset_start_e {
      message(LOW, "detected reset start");
   };

   on reset_end_e {
      message(LOW, "detected reset end");
   };
};

-- 4.2.4. field: list of unit instances
-- Reference: name: list of unit-type is instance;
unit router_u {
// ^ keyword.declaration.class.specman
//   ^^^^^^^^ entity.name.class.specman
//            ^ punctuation.section.class.begin.specman
   channels: list of channel_u is instance;
   keep channels.size() == 3;
};

-- Empty unit definition
unit empty_u {
// ^ keyword.declaration.class.specman
//   ^^^^^^^ entity.name.class.specman
};

-- ==========================================================================
-- 5.1.1. Declaring a Template struct/unit Type
-- Syntax: [package] template (struct|unit) template-name of (param-list)
--     [like base-type] [implementing interface-name, ...]
--     [conditions { [bool-exp;...] }] { [member;...] }
-- ==========================================================================

-- Template struct with package access, type and value parameters
-- Reference: package template struct packet of (<kind'type>, ...) { ... };
package template struct packet of (<kind'type>, <data'type>:numeric, <data_size'exp>:uint) {
// <------ entity.name.namespace.specman
//      ^^^^^^^^ keyword.declaration.template.specman
//               ^^^^^^ keyword.declaration.class.specman
//                      ^^^^^^ entity.name.class.template.specman
//                                 ^ punctuation.separator.specman
//                                  ^^^^ variable.parameter.template.specman
//                                      ^ punctuation.separator.specman
//                                       ^^^^ keyword.declaration.specman
//                                           ^ punctuation.separator.specman
//                                              ^ punctuation.separator.specman
//                                               ^^^^ variable.parameter.template.specman
//                                                   ^ punctuation.separator.specman
//                                                    ^^^^ keyword.declaration.specman
//                                                        ^ punctuation.separator.specman
//                                                         ^ punctuation.separator.specman
//                                                          ^^^^^^^ storage.type.specman
//                                                                   ^ punctuation.separator.specman
//                                                                    ^^^^^^^^^ variable.parameter.template.specman
//                                                                             ^ punctuation.separator.specman
//                                                                              ^^^ keyword.declaration.specman
//                                                                                 ^ punctuation.separator.specman
//                                                                                  ^ punctuation.separator.specman
//                                                                                   ^^^^ storage.type.specman
  size: uint;
//^^^^ variable.other.member.specman
//    ^ punctuation.separator.type.specman
//      ^^^^ storage.type.specman
  data1: <data'type>(bits: <data_size'exp>);
//^^^^^ variable.other.member.specman
//     ^ punctuation.separator.type.specman
//       ^ punctuation.separator.specman
//        ^^^^ variable.parameter.template.specman
//            ^ punctuation.separator.specman
//             ^^^^ keyword.declaration.specman
//                 ^ punctuation.separator.specman
//                   ^^^^ keyword.operator.width-modifier.specman
  data2: <data'type>(bits: <data_size'exp>);
//^^^^^ variable.other.member.specman
//     ^ punctuation.separator.type.specman
//       ^ punctuation.separator.specman
//        ^^^^ variable.parameter.template.specman
//            ^ punctuation.separator.specman
//             ^^^^ keyword.declaration.specman
//                 ^ punctuation.separator.specman
//                   ^^^^ keyword.operator.width-modifier.specman
  kind: <kind'type>;
//^^^^ variable.other.member.specman
//    ^ punctuation.separator.type.specman
//      ^ punctuation.separator.specman
//       ^^^^ variable.parameter.template.specman
//           ^ punctuation.separator.specman
//            ^^^^ keyword.declaration.specman
//                ^ punctuation.separator.specman
  keep size < 256;
//^^^^ keyword.other.constraint.specman
};

-- Template struct with a single type parameter (parens optional per ref 5.1.1)
-- Reference: template struct T of <type> { ... };
template struct simple_container of <type> {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^^^^^^^^^^^^^^ entity.name.class.template.specman
  value: <type>;
};

-- Template struct with like inheritance
-- Reference: template struct t1 of <type> like s { ... };
template struct derived_map of (<key'type>: scalar, <value'type>) like base_map {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^^^^^^^^^ entity.name.class.template.specman
  key: <key'type>;
  value: <value'type>;
};

-- Template struct with parameter defaults and mix of type/value params
-- Reference: template struct foo of (<a'type>, <b'exp>: int, <c'type>) { ... }
template struct foo of (<a'type>, <b'exp>: int, <c'type>) {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^ entity.name.class.template.specman
};

-- Template struct with defaults derived from previous params
-- Reference: template struct t of (<first'type>, <second'type> = int, ...) { ... };
template struct linked of (<first'type>, <second'type> = <first'type>) {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^^^^ entity.name.class.template.specman
  a: <first'type>;
  b: <second'type>;
};

-- Template struct with like, implementing, and conditions
-- Reference: [package] template struct name of (params) [like base]
--     [implementing if,...] [conditions { bool;... }] { ... }
template struct bounded_map of (<key'type>: scalar, <max_size'exp>:uint=1000) like base_container implementing container_if conditions { (<max_size'exp>) > 0; } {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^^^^^^^^^ entity.name.class.template.specman
};

-- ==========================================================================
-- 5.1.4. Template Parameters
-- Type params:  <[tag'] type> [:type-category] [=default-type]
-- Value params: <[tag'] exp>  :scalar-type     [=default-value]
-- Bounding categories: struct, interface, object, list, scalar,
--     numeric, custom_numeric, enum, port
-- ==========================================================================

-- Type parameter with scalar type category bound
-- Reference: <key'type>: scalar
template struct tparam_scalar_bound of (<key'type>: scalar) {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^^^^^^^^^^^^^^^^^ entity.name.class.template.specman
};

-- Value parameter with scalar type
-- Reference: <max_size'exp>:uint=1000
template struct tparam_value of (<max_size'exp>:uint=1000) {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^^^^^^^^^^ entity.name.class.template.specman
};

-- Type parameter with object category
-- Reference: <kind'type>:object
template struct tparam_object_bound of (<kind'type>:object) {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.class.specman
//              ^^^^^^^^^^^^^^^^^^^ entity.name.class.template.specman
};

-- Template unit declaration
-- Reference: template unit monitor_u of (<data'type>) { ... };
template unit monitor_u of (<data'type>) {
// <------- keyword.declaration.template.specman
//       ^^^^ keyword.declaration.class.specman
//            ^^^^^^^^^ entity.name.class.template.specman
  !data: <data'type>;
};

-- Template unit with like
-- Reference: template unit name of (params) like base_unit { ... };
template unit agent_u of (<item'type>) like base_agent_u {
// <------- keyword.declaration.template.specman
//       ^^^^ keyword.declaration.class.specman
//            ^^^^^^^ entity.name.class.template.specman
  !item: <item'type>;
};

-- ==========================================================================
-- 5.1.2. Declaring a Template Interface Type
-- Syntax: [package] template interface template-name of (param-list)
--     [like base-interface-name, ...]
--     [conditions { [bool-exp;...] }] { [interface-member;...] }
-- ==========================================================================

-- Template interface with value parameter, like, and conditions
-- Reference: template interface goo of (params) like foo, bar { ... };
template interface foo_if of (<data'exp>:uint = 1000) like base_if, advanced_if conditions { <data'exp> <= 1000;}
// <------- keyword.declaration.template.specman
//       ^^^^^^^^^ keyword.declaration.class.specman
//                 ^^^^^^ entity.name.class.template.specman
{

};

-- Template interface with multiple type parameters
-- Reference: template interface T of (<first'type>, <second'type>) { ... };
template interface converter_if of (<src'type>, <dst'type>) {
// <------- keyword.declaration.template.specman
//       ^^^^^^^^^ keyword.declaration.class.specman
//                 ^^^^^^^^^^^^ entity.name.class.template.specman
};

-- Package template interface
-- Reference: package template interface name of (params) like base { ... };
package template interface goo_if of (<first'type>, <second'type>) like base_goo_if {
// <------ entity.name.namespace.specman
//      ^^^^^^^^ keyword.declaration.template.specman
//               ^^^^^^^^^ keyword.declaration.class.specman
//                         ^^^^^^ entity.name.class.template.specman
};

-- ==========================================================================
-- 5.2. Extending a Template Struct
-- Syntax: template extend [struct-subtype] template_name of (param-list)
--     [implementing interface-name, ...]
--     [conditions { [bool-exp;...] }] { [member;...] }
-- ==========================================================================

-- Template extend struct with type category bounding
-- Reference: template extend packet of (<kind'type>: enum, <data'type>) { ... };
template extend struct packet of (<kind'type>:object, <data'type>:numeric, <data_size'exp>:uint = MAX_UINT) {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.specman
//              ^^^^^^ keyword.declaration.class.specman
//                     ^^^^^^ entity.name.class.template.specman
   sum_data(): <data'type>(bits: <data_size'exp>) is {
      return data1 + data2;
   };
};

-- Template extend struct with conditions clause
-- Reference: template extend map of (uint, <value'type>:numeric, <max_size'exp>:uint)
--     conditions { (<max_size'exp>) > 1000; } { ... };
template extend struct packet of (<kind'type>: enum, <data'type>:numeric, <data_size'exp>:uint) conditions { type_bit_size(<data'type>) < 64; } {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.specman
//              ^^^^^^ keyword.declaration.class.specman
//                     ^^^^^^ entity.name.class.template.specman
};

-- Template extend unit
-- Reference: template extend unit-template of (params) { ... };
template extend unit monitor_u of (<data'type>) {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.specman
//              ^^^^ keyword.declaration.class.specman
//                   ^^^^^^^^^ entity.name.class.template.specman
};

-- Template extend with implementing
-- Reference: template extend name of (params) implementing if_name { ... };
template extend struct simple_container of (<cont'type>) implementing serializable_if {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.specman
//              ^^^^^^ keyword.declaration.class.specman
//                     ^^^^^^^^^^^^^^^^ entity.name.class.template.specman
};

-- ==========================================================================
-- Additional keyword coverage (uvm_build_config, sequence)
-- ==========================================================================

uvm_build_config env singleagent_flat_env_u singleagent_env_config_u singleagent_env_config_params_s ;
// <------------ keyword.declaration.specman

uvm_build_config agent singleagent_agent_u singleagent_agent_config_u singleagent_agent_config_params_s ;
// <------------ keyword.declaration.specman

sequence singleagent_sequence_s
// <---- keyword.declaration.specman
   using testflow = TRUE,
//       ^^^^^^^^ keyword.declaration.specman
   item           = singleagent_data_item_s,
   created_driver = singleagent_sequence_driver_u,
   created_kind   = singleagent_sequence_kind_t;

-- ==========================================================================
-- The patterns below are known to trigger scope-leaking grammar bugs.
-- They are placed at the end to prevent cascading failures in the above
-- tests. Failing assertions here are expected.
-- ==========================================================================

-- ==========================================================================
-- 5.2 (variant). Template extend without struct/unit keyword
-- Syntax: template extend template_name of (param-list) ... { ... }
-- NOTE: The grammar currently does not handle this form in the templates
-- pattern (which requires struct|unit|interface). This should still be valid
-- per the reference.
-- ==========================================================================

-- Template extend without struct/unit keyword (valid per reference 5.2)
template extend packet of (<kind'type>: enum, <data'type>:numeric, <max_size'exp>:uint) conditions { (<max_size'exp>) > 1000; } {
// <------- keyword.declaration.template.specman
//       ^^^^^^ keyword.declaration.specman
//              ^^^^^^ entity.name.class.template.specman
};

-- ==========================================================================
-- 5.3. Instantiating a Template Type
-- Syntax: template-name of (actual-param-list)
-- Used wherever a type name is expected. Regular extends and when
-- subtypes of template instances follow the same syntax.
-- NOTE: `of (...)` after extend/type-name causes the grammar's "methods"
-- begin pattern to falsely match, opening a scope that never closes.
-- These tests are placed at the end to avoid cascading scope issues.
-- ==========================================================================

-- Regular extend of a template instance (reference 5.3)
-- Reference: extend type-name of (actual-params) { ... }
extend packet of (color, int) {
// <-- keyword.declaration.class.specman
//     ^^^^^^ entity.name.class.specman
};

-- Extend with when subtype of template instance (5.3.2)
-- Reference: red packet of (color, int) is a legal type name
extend red packet of (color, int) {
// <-- keyword.declaration.class.specman
};

-- ==========================================================================
-- 5.1.3. Declaring a Template Numeric Type
-- Syntax: template numeric_type template-name of (param-list):
--     implementing-struct-name [conditions { [bool-exp;...] }];
-- NOTE: `of (...)` on these lines triggers the "methods" begin pattern,
-- which opens a scope that never properly closes. Place LAST to avoid
-- cascading scope pollution.
-- ==========================================================================

-- Reference: template numeric_type my_two_arg_numeric_t of (<t1'type>, <t2'type>):
--     my_tmpl_numeric_s of (<t1'type>, <t2'type>);
template numeric_type my_two_arg_numeric_t of (<t1'type>, <t2'type>): my_tmpl_numeric_s of (<t1'type>, <t2'type>);
// <------- keyword.declaration.template.specman
//       ^^^^^^^^^^^^ keyword.declaration.class.specman
//                    ^^^^^^^^^^^^^^^^^^^^ entity.name.class.template.specman

-- Reference: template numeric_type my_one_arg_numeric_t of (<t1'type>):
--     my_tmpl_numeric_s of (<t1'type>, int);
template numeric_type my_one_arg_numeric_t of (<t1'type>): my_tmpl_numeric_s of (<t1'type>, int);
// <------- keyword.declaration.template.specman
//       ^^^^^^^^^^^^ keyword.declaration.class.specman
//                    ^^^^^^^^^^^^^^^^^^^^ entity.name.class.template.specman

-- Reference: template numeric_type with defaults and bounding
template numeric_type my_bounded_numeric_t of (<t1'type>:numeric=int, <t2'type>= <t1'type>): my_tmpl_numeric_s of (<t1'type>, <t2'type>);
// <------- keyword.declaration.template.specman
//       ^^^^^^^^^^^^ keyword.declaration.class.specman
//                    ^^^^^^^^^^^^^^^^^^^^ entity.name.class.template.specman

'>

//=============================================================================
// EOF
//=============================================================================
