all: torch_bindings_generated.cmx

torch_bindings_generated.cmx: ctypes.cmx cstubs.cmx
cstubs.cmx: cstubs_generate_c.cmx cstubs_generate_ml.cmx cstubs_structs.cmx
cstubs_generate_ml.cmx: ctypes_path.cmx cstubs_analysis.cmx cstubs_public_name.cmx
cstubs_generate_c.cmx: cstubs_c_language.cmx cstubs_emit_c.cmx
cstubs_c_language.cmx: cstubs_errors.cmx
ctypes.cmx: ctypes_static.cmx ctypes_structs_computed.cmx ctypes_type_printing.cmx ctypes_memory.cmx ctypes_std_views.cmx ctypes_value_printing.cmx ctypes_types.cmx
ctypes_static.cmx: ctypes_bigarray.cmx
ctypes_bigarray.cmx: ctypes_bigarray_stubs.cmx ctypes_primitives.cmx ctypes_memory_stubs.cmx
ctypes_bigarray_stubs.cmx: ctypes_ptr.cmx
ctypes_memory.cmx: ctypes_memory_stubs.cmx ctypes_roots_stubs.cmx
ctypes_std_views.cmx: ctypes_std_view_stubs.cmx ctypes_coerce.cmx
ctypes_value_printing.cmx: ctypes_value_printing_stubs.cmx
ctypes_primitives.cmx: ctypes_primitive_types.cmx
ctypes_primitive_types.cmx: unsigned.cmx signed.cmx lDouble.cmx complexL.cmx

%.cmx: %.ml
	ocamlopt -c $@ $<

ctypes_primitives.ml: extract_from_c.ml gen_c_primitives.ml
	ocamlc -o gen_c_primitives str.cma -strict-sequence -linkall $^ -I src/configure
	./gen_c_primitives > $@ 2> gen_c_primitives.log || (rm $@ && cat gen_c_primitives.log || false)

.PHONY: clean
clean:
	rm -f *.o *.cmx *.cmi *.cmo *.log gen_c_primitives
