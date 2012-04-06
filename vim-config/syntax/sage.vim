" Vim syntax file
" Language:	Sage
" Maintainer:	Zoresvit <zoresvit@gmail.com>
"		Fully adapted from Neil Schemenauer's <nas@python.ca> Python
"		syntax file.
" Last Change:	2012 Mar 9
" Credits:	Zvezdan Petkovic <zpetkovic@acm.org>
"		Neil Schemenauer <nas@python.ca>
"		Dmitry Vasiliev
"
"		This version is a major rewrite by Zvezdan Petkovic.
"
"		- introduced highlighting of doctests
"		- updated keywords, built-ins, and exceptions
"		- corrected regular expressions for
"
"		  * functions
"		  * decorators
"		  * strings
"		  * escapes
"		  * numbers
"		  * space error
"
"		- corrected synchronization
"		- more highlighting is ON by default, except
"		- space error highlighting is OFF by default
"
" Optional highlighting can be controlled using these variables.
"
"   let python_no_builtin_highlight = 1
"   let python_no_doctest_code_highlight = 1
"   let python_no_doctest_highlight = 1
"   let python_no_exception_highlight = 1
"   let python_no_number_highlight = 1
"   let python_space_error_highlight = 1
"
" All the options above can be switched on together.
"
"   let python_highlight_all = 1
"

" For version 5.x: Clear all syntax items.
" For version 6.x: Quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

" Keep Python keywords in alphabetical order inside groups for easy
" comparison with the table in the 'Python Language Reference'
" http://docs.python.org/reference/lexical_analysis.html#keywords.
" Groups are in the order presented in NAMING CONVENTIONS in syntax.txt.
" Exceptions come last at the end of each group (class and def below).
"
" Keywords 'with' and 'as' are new in Python 2.6
" (use 'from __future__ import with_statement' in Python 2.5).
"
" Some compromises had to be made to support both Python 3.0 and 2.6.
" We include Python 3.0 features, but when a definition is duplicated,
" the last definition takes precedence.
"
" - 'False', 'None', and 'True' are keywords in Python 3.0 but they are
"   built-ins in 2.6 and will be highlighted as built-ins below.
" - 'exec' is a built-in in Python 3.0 and will be highlighted as
"   built-in below.
" - 'nonlocal' is a keyword in Python 3.0 and will be highlighted.
" - 'print' is a built-in in Python 3.0 and will be highlighted as
"   built-in below (use 'from __future__ import print_function' in 2.6)
"
syn keyword pythonStatement	False, None, True
syn keyword pythonStatement	as assert break continue del exec global
syn keyword pythonStatement	lambda nonlocal pass print return with yield
syn keyword pythonStatement	class def nextgroup=pythonFunction skipwhite
syn keyword pythonConditional	elif else if
syn keyword pythonRepeat	for while
syn keyword pythonOperator	and in is not or
syn keyword pythonException	except finally raise try
syn keyword pythonInclude	from import

" Decorators (new in Python 2.4)
syn match   pythonDecorator	"@" display nextgroup=pythonFunction skipwhite
" The zero-length non-grouping match before the function name is
" extremely important in pythonFunction.  Without it, everything is
" interpreted as a function inside the contained environment of
" doctests.
" A dot must be allowed because of @MyClass.myfunc decorators.
syn match   pythonFunction
      \ "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained

syn match   pythonComment	"#.*$" contains=pythonTodo,@Spell
syn keyword pythonTodo		FIXME NOTE NOTES TODO XXX contained

" Triple-quoted strings can contain doctests.
syn region  pythonString
      \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=pythonEscape,@Spell
syn region  pythonString
      \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell
syn region  pythonRawString
      \ start=+[uU]\=[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  pythonRawString
      \ start=+[uU]\=[rR]\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonSpaceError,pythonDoctest,@Spell

syn match   pythonEscape	+\\[abfnrtv'"\\]+ contained
syn match   pythonEscape	"\\\o\{1,3}" contained
syn match   pythonEscape	"\\x\x\{2}" contained
syn match   pythonEscape	"\%(\\u\x\{4}\|\\U\x\{8}\)" contained
" Python allows case-insensitive Unicode IDs: http://www.unicode.org/charts/
syn match   pythonEscape	"\\N{\a\+\%(\s\a\+\)*}" contained
syn match   pythonEscape	"\\$"

if exists("python_highlight_all")
  if exists("python_no_builtin_highlight")
    unlet python_no_builtin_highlight
  endif
  if exists("python_no_doctest_code_highlight")
    unlet python_no_doctest_code_highlight
  endif
  if exists("python_no_doctest_highlight")
    unlet python_no_doctest_highlight
  endif
  if exists("python_no_exception_highlight")
    unlet python_no_exception_highlight
  endif
  if exists("python_no_number_highlight")
    unlet python_no_number_highlight
  endif
  let python_space_error_highlight = 1
endif

" It is very important to understand all details before changing the
" regular expressions below or their order.
" The word boundaries are *not* the floating-point number boundaries
" because of a possible leading or trailing decimal point.
" The expressions below ensure that all valid number literals are
" highlighted, and invalid number literals are not.  For example,
"
" - a decimal point in '4.' at the end of a line is highlighted,
" - a second dot in 1.0.0 is not highlighted,
" - 08 is not highlighted,
" - 08e0 or 08j are highlighted,
"
" and so on, as specified in the 'Python Language Reference'.
" http://docs.python.org/reference/lexical_analysis.html#numeric-literals
if !exists("python_no_number_highlight")
  " numbers (including longs and complex)
  syn match   pythonNumber	"\<0[oO]\=\o\+[Ll]\=\>"
  syn match   pythonNumber	"\<0[xX]\x\+[Ll]\=\>"
  syn match   pythonNumber	"\<0[bB][01]\+[Ll]\=\>"
  syn match   pythonNumber	"\<\%([1-9]\d*\|0\)[Ll]\=\>"
  syn match   pythonNumber	"\<\d\+[jJ]\>"
  syn match   pythonNumber	"\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
  syn match   pythonNumber
	\ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
  syn match   pythonNumber
	\ "\%(^\|\W\)\@<=\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"
endif

" Group the built-ins in the order in the 'Python Library Reference' for
" easier comparison.
" http://docs.python.org/library/constants.html
" http://docs.python.org/library/functions.html
" http://docs.python.org/library/functions.html#non-essential-built-in-functions
" Python built-in functions are in alphabetical order.
if !exists("python_no_builtin_highlight")
  " built-in constants
  " 'False', 'True', and 'None' are also reserved words in Python 3.0
  syn keyword pythonBuiltin	False True None
  syn keyword pythonBuiltin	NotImplemented Ellipsis __debug__
  " built-in functions
  syn keyword pythonBuiltin	abs all any bin bool chr classmethod
  syn keyword pythonBuiltin	compile complex delattr dict dir divmod
  syn keyword pythonBuiltin	enumerate eval filter float format
  syn keyword pythonBuiltin	frozenset getattr globals hasattr hash
  syn keyword pythonBuiltin	help hex id input int isinstance
  syn keyword pythonBuiltin	issubclass iter len list locals map max
  syn keyword pythonBuiltin	min next object oct open ord pow print
  syn keyword pythonBuiltin	property range repr reversed round set
  syn keyword pythonBuiltin	setattr slice sorted staticmethod str
  syn keyword pythonBuiltin	sum super tuple type vars zip __import__
  " Python 2.6 only
  syn keyword pythonBuiltin	basestring callable cmp execfile file
  syn keyword pythonBuiltin	long raw_input reduce reload unichr
  syn keyword pythonBuiltin	unicode xrange
  " Python 3.0 only
  syn keyword pythonBuiltin	ascii bytearray bytes exec memoryview
  " non-essential built-in functions; Python 2.6 only
  syn keyword pythonBuiltin	apply buffer coerce intern

  " Sage specific functions and variables
  syn keyword pythonBuiltin paretovariate is_MPolynomial cartan_matrix 
  syn keyword pythonBuiltin is_NumberFieldElement elliptic_curves sleep 
  syn keyword pythonBuiltin lie_console is_AmbientSpace LLTHSpin IntegerRange 
  syn keyword pythonBuiltin matlab ProjectiveHypersurface GU install_scripts 
  syn keyword pythonBuiltin PerfectMatchings CubeGroup continuant GF 
  syn keyword pythonBuiltin order_from_bounds GO DiagonalQuadraticForm GL 
  syn keyword pythonBuiltin AlgebraicReal Gp ShrinkingGeneratorCryptosystem 
  syn keyword pythonBuiltin RingElement vector DedekindDomain math 
  syn keyword pythonBuiltin unpickle_persistent entropy point2d wronskian 
  syn keyword pythonBuiltin is_ModuleElement HopfAlgebras WordMorphism 
  syn keyword pythonBuiltin is_FractionField asin minimize is_KashElement 
  syn keyword pythonBuiltin hamming_upper_bound is_ProjectiveSpace circle 
  syn keyword pythonBuiltin pickle_function unpickle_global 
  syn keyword pythonBuiltin dimension_modular_forms ecm Partitions 
  syn keyword pythonBuiltin EnumeratedSet extend_to_primitive LaurentSeries 
  syn keyword pythonBuiltin golden_ratio Profiler SetPartitionsBk ZZ 
  syn keyword pythonBuiltin spike_function GraphQuery ttest CombinatorialObject 
  syn keyword pythonBuiltin GradedBialgebrasWithBasis LinearCodeFromCheckMatrix 
  syn keyword pythonBuiltin VectorSpaces TermOrder Zp Zq sage0_version 
  syn keyword pythonBuiltin is_FreeMonoidElement set_verbose_files WordOptions 
  syn keyword pythonBuiltin sloane exponential_integral_1 supersingular_D 
  syn keyword pythonBuiltin merge_points unset_verbose_files plot 
  syn keyword pythonBuiltin supersingular_j _24 trivial_character 
  syn keyword pythonBuiltin InnerProductSpace HillCryptosystem is_Functor 
  syn keyword pythonBuiltin prime_divisors additive_order 
  syn keyword pythonBuiltin FilteredCombinatorialClass Cusps 
  syn keyword pythonBuiltin ExtendedTernaryGolayCode cunningham_prime_factors 
  syn keyword pythonBuiltin join desolvers fast_float SetPartitionsPk RLF 
  syn keyword pythonBuiltin FreeAlgebra erf mq is_GlobalGenus 
  syn keyword pythonBuiltin PosetOfRestrictedIntegerPartitions macaulay2_console 
  syn keyword pythonBuiltin base_ring Li EuclideanDomainElement fibonacci 
  syn keyword pythonBuiltin is_AlgebraicField lngamma Posets delta_qexp 
  syn keyword pythonBuiltin Macaulay2 get_inverse_mod end ComplexDoubleElement 
  syn keyword pythonBuiltin hom convergents polytopes pAdicRing UnitGroup 
  syn keyword pythonBuiltin number_of_ordered_partitions MatrixSpace colormaps 
  syn keyword pythonBuiltin Subsets hg_extcode CFF Sequences SageObject ZpFM 
  syn keyword pythonBuiltin StandardRibbons __ acsch vars Piecewise Alphabet 
  syn keyword pythonBuiltin krull_dimension normalvariate ToricLattice 
  syn keyword pythonBuiltin TernaryGolayCode JonesDatabase ModularFormsRing 
  syn keyword pythonBuiltin is_DedekindDomain QuotientFields Semirings 
  syn keyword pythonBuiltin LatticeDiagram RealDoubleElement DiamondPoset _i 
  syn keyword pythonBuiltin point3d is_ProbabilitySpace animate squarefree_part 
  syn keyword pythonBuiltin IncidenceStructureFromMatrix ChainComplexes 
  syn keyword pythonBuiltin SymmetricGroupRepresentation arctan2 Sets 
  syn keyword pythonBuiltin scatter_plot mwrank_get_precision 
  syn keyword pythonBuiltin is_DedekindDomainElement BooleanPolynomialRing 
  syn keyword pythonBuiltin polar_plot FiniteEnumeratedSet 
  syn keyword pythonBuiltin UnionCombinatorialClass _8 _7 _6 _5 dumps 
  syn keyword pythonBuiltin branch_weyl_character arrow RandomPoset 
  syn keyword pythonBuiltin disk_cached_function attrcall with_statement 
  syn keyword pythonBuiltin ElementWrapper weibullvariate 
  syn keyword pythonBuiltin coincidence_discriminant SetPartitionsAk 
  syn keyword pythonBuiltin backtrack_all AlgebraModules DyckWords 
  syn keyword pythonBuiltin is_FreeQuadraticModule AlgebrasWithBasis _ii 
  syn keyword pythonBuiltin Hasse_bounds log2 GCD is_commutative ntl 
  syn keyword pythonBuiltin SteinWatkinsAllData sys QuaternionAlgebra arccot 
  syn keyword pythonBuiltin inverse_mod arccos is_EllipticCurve SkewPartition 
  syn keyword pythonBuiltin pyrex is_square rank is_squarefree is_ParentWithBase 
  syn keyword pythonBuiltin Bessel two_squares IntegralDomains next_prime top 
  syn keyword pythonBuiltin runsnake wigner_9j QuaternionGroup 
  syn keyword pythonBuiltin trivial_covering_design EisensteinForms pretty_print 
  syn keyword pythonBuiltin cubical_complexes Factorization is_pAdicField Set 
  syn keyword pythonBuiltin regulator dimension_eis random_sublist 
  syn keyword pythonBuiltin mwrank_set_precision random_prime 
  syn keyword pythonBuiltin is_NumberFieldIdeal seed 
  syn keyword pythonBuiltin vector_callable_symbolic_dense symbolic_expression 
  syn keyword pythonBuiltin steenrod_algebra_basis cremona_optimal_curves 
  syn keyword pythonBuiltin CremonaModularSymbols is_MPolynomialIdeal 
  syn keyword pythonBuiltin plot_vector_field3d infix_operator 
  syn keyword pythonBuiltin discrete_log_lambda SAGE_TMP SteinWatkinsPrimeData 
  syn keyword pythonBuiltin get_remote_file Qq Qp heegner_points denominator 
  syn keyword pythonBuiltin fibonacci_xrange simplify is_CommutativeRingElement 
  syn keyword pythonBuiltin bernoulli_polynomial QQ prime_powers alarm partition 
  syn keyword pythonBuiltin coercion_traceback points hypergeometric_U 
  syn keyword pythonBuiltin EuclideanDomains tmp_filename NonattackingFillings 
  syn keyword pythonBuiltin FrozenBitset is_MonoidElement load_session 
  syn keyword pythonBuiltin PartitionTuples dimension_cusp_forms random sage 
  syn keyword pythonBuiltin kronecker_delta PariRing 
  syn keyword pythonBuiltin EllipticCurve_from_plane_curve mwrank 
  syn keyword pythonBuiltin is_SchemeMorphism is_IntegralDomain error_fcn 
  syn keyword pythonBuiltin column_matrix RibbonTableau Octave integrate axiom 
  syn keyword pythonBuiltin hamming_bound_asymp db ceil set_verbose 
  syn keyword pythonBuiltin PowComputer_ext_maker SkewPartitions 
  syn keyword pythonBuiltin JackPolynomialsQp jacobi_symbol heaviside real_part 
  syn keyword pythonBuiltin ParentWithAdditiveAbelianGens eulers_method 
  syn keyword pythonBuiltin PartitionsInBox gegenbauer reference 
  syn keyword pythonBuiltin continued_fraction plot_step_function Spec Cusp 
  syn keyword pythonBuiltin tensor AlgebraElement CuspForms integer_ring mul 
  syn keyword pythonBuiltin GammaH WittDesign ShiftCryptosystem 
  syn keyword pythonBuiltin partitions_greatest toric_varieties PSp SFASchur 
  syn keyword pythonBuiltin is_LaurentPolynomialRing is_AlgebraElement cot PSL 
  syn keyword pythonBuiltin SloaneEncyclopedia catalan_number Ideals 
  syn keyword pythonBuiltin hamming_weight cyclic_permutations_of_partition 
  syn keyword pythonBuiltin OneExactCover PartitionsGreatestLE MatrixGroup PSU 
  syn keyword pythonBuiltin AllCusps DiGraph cartesian_product_iterator diff 
  syn keyword pythonBuiltin DiCyclicGroup basis union is_CommutativeRing 
  syn keyword pythonBuiltin Euler_Phi QuadraticSpace quadratic_residues 
  syn keyword pythonBuiltin hecke_operator_on_qexp macaulay2 plot_slope_field 
  syn keyword pythonBuiltin acoth CC odd_part lift 
  syn keyword pythonBuiltin random_quadraticform_with_conditions 
  syn keyword pythonBuiltin hilbert_conductor InfinityRing tanh 
  syn keyword pythonBuiltin is_DirichletGroup lfsr_autocorrelation n 
  syn keyword pythonBuiltin AbelianStratum is_NumberFieldFractionalIdeal 
  syn keyword pythonBuiltin is_prime_power Ideal random_digraph AbstractCategory 
  syn keyword pythonBuiltin Coalgebras interacts OctalStrings 
  syn keyword pythonBuiltin is_NumberFieldOrder firing_vector SphericalElevation 
  syn keyword pythonBuiltin NaN DivisionRings get_memory_usage power_mod 
  syn keyword pythonBuiltin GraphBundle Domains is_VectorSpace MultichooseNK 
  syn keyword pythonBuiltin is_GapElement AugmentedLatticeDiagramFilling 
  syn keyword pythonBuiltin quadratic_L_function__numerical 
  syn keyword pythonBuiltin combinations_iterator lfsr_sequence MeetSemilattice 
  syn keyword pythonBuiltin _i5 degree_lowest_rational_function maxima get_gcd 
  syn keyword pythonBuiltin block_diagonal_matrix xmrange_iter ones_matrix 
  syn keyword pythonBuiltin partitions_restricted cyclic_permutations_iterator 
  syn keyword pythonBuiltin verbose mrange Gap farey tuples Rngs save 
  syn keyword pythonBuiltin number_of_partitions self_orthogonal_binary_codes 
  syn keyword pythonBuiltin lcm JackPolynomialsJ spherical_harmonic minpoly 
  syn keyword pythonBuiltin Gamma0 manual AffineCryptosystem AlgebraicField 
  syn keyword pythonBuiltin ContinuedFractionField JackPolynomialsP 
  syn keyword pythonBuiltin JackPolynomialsQ _dh absolute_igusa_invariants_kohel 
  syn keyword pythonBuiltin list_plot3d P1List NumberFieldTower flatten digraphs 
  syn keyword pythonBuiltin designs_from_XML_url is_integrally_closed line2d 
  syn keyword pythonBuiltin tutorial uniq fibonacci_sequence IndexedSequence 
  syn keyword pythonBuiltin constructions prime_pi SphericalDistribution 
  syn keyword pythonBuiltin partitions_list MonoidElement vecsmall_to_intlist 
  syn keyword pythonBuiltin is_pseudoprime ReflexivePolytopes binomial sandlib 
  syn keyword pythonBuiltin Cores FiniteWeylGroups elliptic_eu numerator 
  syn keyword pythonBuiltin ComplexIntervalField elliptic_ec acos elliptic_pi 
  syn keyword pythonBuiltin CyclicPermutationsOfPartition acot CrystalOfSpins 
  syn keyword pythonBuiltin min_cycles get_branching_rule RingModules 
  syn keyword pythonBuiltin database_install SearchForest is_HyperellipticCurve 
  syn keyword pythonBuiltin ModularAbelianVarieties qepcad_formula 
  syn keyword pythonBuiltin is_AbsoluteNumberField PrincipalIdealDomain arccsc 
  syn keyword pythonBuiltin fork walsh_matrix latex firing_graph xgcd 
  syn keyword pythonBuiltin differences complete_sandpile reset_load_attach_path 
  syn keyword pythonBuiltin FastCrystal true set_edit_template reset 
  syn keyword pythonBuiltin is_NumberFieldFractionalIdeal_rel base_field 
  syn keyword pythonBuiltin YangBaxterGraph PermutationGroupElement _20 
  syn keyword pythonBuiltin squarefree_divisors arccosh 
  syn keyword pythonBuiltin HeckeAlgebraSymmetricGroupT load_attach_path 
  syn keyword pythonBuiltin clear_vars BialgebrasWithBasis convergent 
  syn keyword pythonBuiltin UnwrappingMorphism cyclotomic_cosets log_gamma 
  syn keyword pythonBuiltin GradedModules floor QuasiQuadraticResidueCode 
  syn keyword pythonBuiltin cython_create_local_so max_clique ClonableArray 
  syn keyword pythonBuiltin DuadicCodeEvenPair DualAbelianGroup_class 
  syn keyword pythonBuiltin Riemann_Map is_ComplexNumber Monoids merten 
  syn keyword pythonBuiltin elias_bound_asymp assume 
  syn keyword pythonBuiltin FiniteDimensionalCoalgebrasWithBasis 
  syn keyword pythonBuiltin NFCusps_clear_cache interval maxima_calculus 
  syn keyword pythonBuiltin PentagonPoset GSets AffineSpace LLTHCospin zetaderiv 
  syn keyword pythonBuiltin is_VectorSpaceMorphism primes sidon_sets arcsec 
  syn keyword pythonBuiltin ToricVariety random_matrix Singular 
  syn keyword pythonBuiltin QuadraticResidueCodeEvenPair is_MagmaElement 
  syn keyword pythonBuiltin primes_first_n PartiallyOrderedMonoids 
  syn keyword pythonBuiltin reciprocal_trig_functions getrandbits 
  syn keyword pythonBuiltin CrystalOfTableaux RealNumber 
  syn keyword pythonBuiltin ClassicalModularPolynomialDatabase choice 
  syn keyword pythonBuiltin is_VectorSpaceHomspace QuadraticResidueCodeOddPair 
  syn keyword pythonBuiltin hilbert_conductor_inverse partitions Polyhedron dim 
  syn keyword pythonBuiltin graph_db_info ParentWithMultiplicativeAbelianGens 
  syn keyword pythonBuiltin CoveringDesign log_html loads round Tableau cosh 
  syn keyword pythonBuiltin falling_factorial imag_part DihedralGroup 
  syn keyword pythonBuiltin rational_reconstruction uniform block_matrix SO 
  syn keyword pythonBuiltin python_help FiniteFieldElement OrderedPartitions 
  syn keyword pythonBuiltin ProjectiveGeometryDesign NFCusp 
  syn keyword pythonBuiltin FinitePermutationGroups is_Scheme graph_coloring 
  syn keyword pythonBuiltin parse_cremona_label is_EuclideanDomain 
  syn keyword pythonBuiltin is_ParentWithAdditiveAbelianGens weakref 
  syn keyword pythonBuiltin is_IntegralDomainElement is_AlgebraicScheme 
  syn keyword pythonBuiltin is_RandomVariable hg_sage is_CyclotomicField 
  syn keyword pythonBuiltin convolution preparse hermite 
  syn keyword pythonBuiltin cm_j_invariants_and_orders generic_cmp gamma_inc 
  syn keyword pythonBuiltin unordered_tuples SchubertPolynomialRing 
  syn keyword pythonBuiltin PermutationGroupMorphism_im_gens QuadraticForm 
  syn keyword pythonBuiltin Mutability codesize_upper_bound frobby 
  syn keyword pythonBuiltin BinaryQF_reduced_representatives 
  syn keyword pythonBuiltin FiniteEnumeratedSets TensorProductOfCrystals line3d 
  syn keyword pythonBuiltin Expression search_doc fast_arith RealIntervalField 
  syn keyword pythonBuiltin is_ModularAbelianVariety Family gv_bound_asymp Sage 
  syn keyword pythonBuiltin Out padic_printing EnumeratedSets fricas sample 
  syn keyword pythonBuiltin cremona_letter_code ParentWithGens sphere 
  syn keyword pythonBuiltin is_MultiplicativeGroupElement strip_encoding 
  syn keyword pythonBuiltin pAdicField elementary_matrix euler_number atan LiE 
  syn keyword pythonBuiltin Curve Axiom ode_system is_SchubertPolynomial 
  syn keyword pythonBuiltin Newforms enumerate_totallyreal_fields_prim 
  syn keyword pythonBuiltin add_strings SAGE_ROOT InfiniteEnumeratedSets 
  syn keyword pythonBuiltin partitions_greatest_eq GradedAlgebrasWithBasis 
  syn keyword pythonBuiltin PolynomialQuotientRingElement abstract_method gap sh 
  syn keyword pythonBuiltin best_known_covering_design_www 
  syn keyword pythonBuiltin AffineCrystalFromClassical SymmetricFunctions PGL 
  syn keyword pythonBuiltin is_FreeAlgebra SimplicialComplexMorphism unit_step 
  syn keyword pythonBuiltin PermutationGroupMap group RR HallLittlewoodQ 
  syn keyword pythonBuiltin HallLittlewoodP plot_vector_field jacobi_P 
  syn keyword pythonBuiltin ToricIdeal finance is_Algebra 
  syn keyword pythonBuiltin DisjointUnionEnumeratedSets clebsch_invariants 
  syn keyword pythonBuiltin CPRFanoToricVariety density_plot ComplexLazyField 
  syn keyword pythonBuiltin import_statements 
  syn keyword pythonBuiltin FiniteDimensionalHopfAlgebrasWithBasis 
  syn keyword pythonBuiltin AbelianGroupElement SubstitutionCryptosystem getitem 
  syn keyword pythonBuiltin is_ModularSymbolsSpace octave_version 
  syn keyword pythonBuiltin is_FreeModuleHomspace partitions_tuples is_Endset 
  syn keyword pythonBuiltin gv_info_rate SemistandardSkewTableaux 
  syn keyword pythonBuiltin complex_cubic_spline vonmisesvariate is_Morphism 
  syn keyword pythonBuiltin PrincipalIdealDomainElement __builtins__ 
  syn keyword pythonBuiltin incomplete_gamma explain_pickle 
  syn keyword pythonBuiltin is_ModularSymbolsElement CommutativeAlgebraIdeals 
  syn keyword pythonBuiltin gap3 ___ Sigma primitive_root WeylGroupElement 
  syn keyword pythonBuiltin LyndonWords plotkin_bound_asymp 
  syn keyword pythonBuiltin number_of_permutations SAGE_DB is_MatrixSpace view 
  syn keyword pythonBuiltin kernel variables FriCAS one multiplication_names 
  syn keyword pythonBuiltin Primes is_RelativeNumberField hadamard_matrix_www 
  syn keyword pythonBuiltin magma_free exists CyclicSievingCheck install_package 
  syn keyword pythonBuiltin number_of_arrangements number_of_divisors 
  syn keyword pythonBuiltin is_HexadecimalStringMonoidElement Poset hue bessel_Y 
  syn keyword pythonBuiltin CLF bessel_K bessel_J bessel_I FaceFan 
  syn keyword pythonBuiltin CrystalOfSpinsMinus copy AlternatingSignMatrices 
  syn keyword pythonBuiltin cremona_curves is_Parent is_prime 
  syn keyword pythonBuiltin SemistandardMultiSkewTableaux Magma AbelianVariety 
  syn keyword pythonBuiltin singular_version SymmetricFunctionAlgebra 
  syn keyword pythonBuiltin ReflexivePolytope PointConfiguration composite_field 
  syn keyword pythonBuiltin is_Homset Field WeightRing Matlab glue_graphs 
  syn keyword pythonBuiltin clique_number SymmetricGroupWeakOrderPoset 
  syn keyword pythonBuiltin AdditiveAbelianGroupWrapper unsigned_infinity ideal 
  syn keyword pythonBuiltin KostkaFoulkesPolynomial fcp solve_ineq multiple 
  syn keyword pythonBuiltin trace dimension_new_cusp_forms random_vector 
  syn keyword pythonBuiltin number_of_tuples ComplexDoubleField pager P1NFList 
  syn keyword pythonBuiltin HeilbronnMerel ellipsis_iter partitions_set order 
  syn keyword pythonBuiltin dodecahedron FastFourierTransform 
  syn keyword pythonBuiltin DiscreteProbabilitySpace sigma is_RingElement 
  syn keyword pythonBuiltin TrivialCode ConstantFunction show log_text 
  syn keyword pythonBuiltin HomCategory matrix_plot HallLittlewoodQp upgrade 
  syn keyword pythonBuiltin is_AlgebraicRealField is_FreeAbelianMonoidElement 
  syn keyword pythonBuiltin is_IntegerMod RIF is_ParentWithGens 
  syn keyword pythonBuiltin isogeny_codomain_from_kernel conway_polynomial 
  syn keyword pythonBuiltin zeta_symmetric Conic AbelianGroup_class gen 
  syn keyword pythonBuiltin HopfAlgebrasWithBasis median SkewTableau racah wiki 
  syn keyword pythonBuiltin kronecker_character random_DAG ZonalPolynomials 
  syn keyword pythonBuiltin Rings search_src max_symbolic CombinatorialClass 
  syn keyword pythonBuiltin CRT_basis is_ParentWithMultiplicativeAbelianGens 
  syn keyword pythonBuiltin GradedHopfAlgebras timeit NonNegativeIntegers 
  syn keyword pythonBuiltin DualAbelianGroup triangle_sandpile 
  syn keyword pythonBuiltin branching_rule_from_plethysm parent derangements 
  syn keyword pythonBuiltin MapCombinatorialClass is_ComplexDoubleElement 
  syn keyword pythonBuiltin set_modsym_print_mode make_dlxwrapper laplace 
  syn keyword pythonBuiltin is_optimal_id CommutativeAdditiveSemigroups 
  syn keyword pythonBuiltin ComplexNumber TruncatedStaircases HeilbronnCremona 
  syn keyword pythonBuiltin is_Integer ComplexIntervalFieldElement QpCR 
  syn keyword pythonBuiltin balanced_sum next_probable_prime DLXCPP log_b 
  syn keyword pythonBuiltin kash_console CrystalOfLetters GroupAlgebra 
  syn keyword pythonBuiltin is_CallableSymbolicExpressionRing integer_ceil 
  syn keyword pythonBuiltin colors arcsin cputime direct_product_permgroups 
  syn keyword pythonBuiltin SetPartitionsRk 
  syn keyword pythonBuiltin AffineCrystalFromClassicalAndPromotion EtaGroup 
  syn keyword pythonBuiltin airy_ai CoxeterGroups euler_phi bernoulli_mod_p 
  syn keyword pythonBuiltin MonoidAlgebras ModulesWithBasis algdep 
  syn keyword pythonBuiltin CommutativeAlgebras MultiSkewTableau magma_console 
  syn keyword pythonBuiltin CyclicPermutations gfan HeckeModules CRT_list html 
  syn keyword pythonBuiltin mathematica_console gap_console unpickle_extension 
  syn keyword pythonBuiltin DeltaComplex rainbow I nest Modules 
  syn keyword pythonBuiltin is_AbelianGroupElement cyclotomic_polynomial 
  syn keyword pythonBuiltin octahedron region_plot cyclic_permutations 
  syn keyword pythonBuiltin GraphPaths Gamma polygon Spherical gap3_console 
  syn keyword pythonBuiltin InfiniteAbstractCombinatorialClass 
  syn keyword pythonBuiltin is_DirichletCharacter GradedModulesWithBasis 
  syn keyword pythonBuiltin FieldElement solve EuclideanDomain In IntList 
  syn keyword pythonBuiltin dimension symmetrica polygen LatinSquare_generator 
  syn keyword pythonBuiltin CachedFunction powerset multiples 
  syn keyword pythonBuiltin AffineNilTemperleyLiebTypeA SFAPower 
  syn keyword pythonBuiltin WaveletTransform DifferentialForm 
  syn keyword pythonBuiltin is_ComplexIntervalFieldElement 
  syn keyword pythonBuiltin StandardBracketedLyndonWords real psi 
  syn keyword pythonBuiltin SemistandardTableaux abs_symbolic Magmas hg_root 
  syn keyword pythonBuiltin CommutativeAdditiveGroups RealDoubleField 
  syn keyword pythonBuiltin UniqueRepresentation AlgebraIdeals mod _sh read_data 
  syn keyword pythonBuiltin Schemes FreeAlgebraQuotient Groupoid sxrange polylog 
  syn keyword pythonBuiltin eulers_method_2x2_plot sympow magma 
  syn keyword pythonBuiltin is_RealIntervalFieldElement is_Polynomial 
  syn keyword pythonBuiltin UnsignedInfinityRing heegner_point 
  syn keyword pythonBuiltin DirectSumOfCrystals decomposition crt_basis 
  syn keyword pythonBuiltin OrderedSetPartitions show_identifiers power 
  syn keyword pythonBuiltin Partition ChainComplex gp_version 
  syn keyword pythonBuiltin KazhdanLusztigPolynomial __name__ is_LaurentSeries _ 
  syn keyword pythonBuiltin walltime oo input_box ferrers_diagram is_GpElement 
  syn keyword pythonBuiltin mean os desolve_rk4 xinterval image 
  syn keyword pythonBuiltin is_FiniteFieldElement NonDecreasingParkingFunctions 
  syn keyword pythonBuiltin operator gen_legendre_P gen_legendre_Q spline 
  syn keyword pythonBuiltin airy_bi Infinity log NN legendre_symbol 
  syn keyword pythonBuiltin newton_method_sizes unpickle_newobj IntegerMod 
  syn keyword pythonBuiltin number_field_elements_from_algebraics 
  syn keyword pythonBuiltin coincidence_index berlekamp_massey 
  syn keyword pythonBuiltin MultiplicativeGroupElement Integer 
  syn keyword pythonBuiltin FiniteCoxeterGroups GraphDatabase Sudoku OrderedSets 
  syn keyword pythonBuiltin twinprime WordPaths number_of_combinations RDF 
  syn keyword pythonBuiltin divisors mathml pretty_print_default addgp 
  syn keyword pythonBuiltin LFSRCryptosystem Color frequency_distribution taylor 
  syn keyword pythonBuiltin Mathematica CrystalOfSpinsPlus BrandtModule 
  syn keyword pythonBuiltin PosetOfIntegerCompositions DirichletGroup is_Module 
  syn keyword pythonBuiltin CyclotomicField lift_to_sl2z permutation_action 
  syn keyword pythonBuiltin AbelianGroupMorphism_id mathematica 
  syn keyword pythonBuiltin AffineGeometryDesign sage_mode hg_sagenb Fields 
  syn keyword pythonBuiltin SFAElementary is_FreeModuleMorphism sage_input 
  syn keyword pythonBuiltin func_persist AtkinModularPolynomialDatabase 
  syn keyword pythonBuiltin is_QuadraticForm is_Ideal EtaProduct word_problem 
  syn keyword pythonBuiltin hmm CombinatorialAlgebra show_default DisjointSet 
  syn keyword pythonBuiltin acsc elliptic_e elliptic_f forget Unknown 
  syn keyword pythonBuiltin rising_factorial elliptic_j 
  syn keyword pythonBuiltin eisenstein_series_lseries disc acosh disk 
  syn keyword pythonBuiltin implicit_plot3d PariError multinomial_coefficients 
  syn keyword pythonBuiltin GradedHopfAlgebrasWithBasis JoinSemilattice 
  syn keyword pythonBuiltin hadamard_matrix norm plot3d PowerSeries 
  syn keyword pythonBuiltin Genus2reduction integer_floor 
  syn keyword pythonBuiltin KirillovReshetikhinCrystal numerical_eigenforms 
  syn keyword pythonBuiltin input_grid CRT_vectors arcsech range_slider 
  syn keyword pythonBuiltin cartesian_product wilmes_algorithm lisp Tableaux 
  syn keyword pythonBuiltin stirling_number1 stirling_number2 
  syn keyword pythonBuiltin permutations_iterator Ring Semigroups 
  syn keyword pythonBuiltin SetPartitionsIk wigner_3j sturm_bound zero Word 
  syn keyword pythonBuiltin text3d hilbert_symbol IdentityFunctor 
  syn keyword pythonBuiltin characteristic_polynomial MPolynomialRing 
  syn keyword pythonBuiltin singular_console sum unpickle_function 
  syn keyword pythonBuiltin TransitiveGroup version NonDecreasingParkingFunction 
  syn keyword pythonBuiltin cython_lambda is_FreeModule spherical_plot3d 
  syn keyword pythonBuiltin FiniteField EllipticCurve_from_c4c6 Zmod sloane_find 
  syn keyword pythonBuiltin Cone specialize quotient shuffle 
  syn keyword pythonBuiltin is_ModularFormsSpace IncidenceStructure DyckWord 
  syn keyword pythonBuiltin FiniteFields Core Elements 
  syn keyword pythonBuiltin HyperbolicPlane_quadratic_form lazy_import 
  syn keyword pythonBuiltin GeneralDiscreteDistribution povray 
  syn keyword pythonBuiltin ChainComplexMorphism Sq Sp objgen qexp_eta 
  syn keyword pythonBuiltin AdditiveAbelianGroupWrapperElement ContreTableaux 
  syn keyword pythonBuiltin LinearCodeFromVectorSpace bernoulli_mod_p_single SR 
  syn keyword pythonBuiltin ModularForms det SU solve_mod 
  syn keyword pythonBuiltin is_DiscreteProbabilitySpace SL 
  syn keyword pythonBuiltin is_DualAbelianGroupElement icosahedron 
  syn keyword pythonBuiltin maxima_console NumberFieldElement coerce Tuples 
  syn keyword pythonBuiltin AbelianGroupMap get_coercion_model species isqrt 
  syn keyword pythonBuiltin atanh csc discrete_log_generic PGU 
  syn keyword pythonBuiltin random_quadraticform zero_matrix 
  syn keyword pythonBuiltin wiki_create_instance Bimodules Lisp 
  syn keyword pythonBuiltin ExtendedBinaryGolayCode 
  syn keyword pythonBuiltin ClassicalCrystalOfAlcovePaths LatticePoset 
  syn keyword pythonBuiltin CombinatorialFreeModule sech is_even atan2 
  syn keyword pythonBuiltin SteenrodAlgebra parametric_plot find_root bsgs 
  syn keyword pythonBuiltin checkbox help coxeter_matrix ProjectiveSpace arccoth 
  syn keyword pythonBuiltin cyclic_permutations_of_partition_iterator 
  syn keyword pythonBuiltin prime_factors developer TranspositionCryptosystem 
  syn keyword pythonBuiltin is_package_installed is_Spec is_MPolynomialRing 
  syn keyword pythonBuiltin GcdDomains Objects jacobi set_random_seed bar_chart 
  syn keyword pythonBuiltin detach is_AbelianGroup PolynomialQuotientRing 
  syn keyword pythonBuiltin fundamental_discriminant prime_range 
  syn keyword pythonBuiltin CyclicCodeFromCheckPolynomial __IP 
  syn keyword pythonBuiltin number_of_partitions_restricted End StandardTableau 
  syn keyword pythonBuiltin number_of_derangements mwrank_MordellWeil 
  syn keyword pythonBuiltin is_RealField is_field Combinations 
  syn keyword pythonBuiltin UniqueFactorizationDomains 
  syn keyword pythonBuiltin is_PermutationGroupElement is_FreeModuleElement 
  syn keyword pythonBuiltin min_symbolic lcalc FormalSums SFAHomogeneous 
  syn keyword pythonBuiltin gaussian_binomial Ei ReedSolomonCode hecke_operator 
  syn keyword pythonBuiltin EtaGroupElement OverconvergentModularForms ECM 
  syn keyword pythonBuiltin ParentWithBase laguerre radical ode_solver misc 
  syn keyword pythonBuiltin dimension_supersingular_module BlockDesign 
  syn keyword pythonBuiltin complex_plot Minimog maple view_all is_RElement 
  syn keyword pythonBuiltin get_verbose interact qepcad_version CartesianProduct 
  syn keyword pythonBuiltin ClasscallMetaclass QuadraticField DuadicCodeOddPair 
  syn keyword pythonBuiltin pari selector EquationOrder 
  syn keyword pythonBuiltin FiniteDimensionalModulesWithBasis sign std 
  syn keyword pythonBuiltin num_cusps_of_width CremonaDatabase SymmetricGroup 
  syn keyword pythonBuiltin eta_poly_relations polygens Mupad is_InfinityElement 
  syn keyword pythonBuiltin is_32_bit graphics_array HadamardDesign 
  syn keyword pythonBuiltin DifferentialForms conjugate mupad 
  syn keyword pythonBuiltin previous_prime_power theta2_qexp lie NefPartition 
  syn keyword pythonBuiltin is_Infinite PosetOfIntegerPartitions randint lim 
  syn keyword pythonBuiltin legendre_Q legendre_P LatticePolytope 
  syn keyword pythonBuiltin singleton_upper_bound CommutativeAlgebraElement 
  syn keyword pythonBuiltin expovariate lucas_number1 lucas_number2 
  syn keyword pythonBuiltin inverse_laplace RealLazyField attached_files 
  syn keyword pythonBuiltin BinaryTree set_default_variable_name GradedAlgebras 
  syn keyword pythonBuiltin Permutations ngens exp scilab _i23 
  syn keyword pythonBuiltin GradedCoalgebrasWithBasis sig_on_count 
  syn keyword pythonBuiltin desolve_system xmrange simplicial_complexes Moebius 
  syn keyword pythonBuiltin JH Rational clebsch_gordan vector_symbolic_dense 
  syn keyword pythonBuiltin AntichainPoset polymake copyright iet color_selector 
  syn keyword pythonBuiltin factor QuarticCurve SymmetricGroupRepresentations 
  syn keyword pythonBuiltin ResidueField kash_version combinations 
  syn keyword pythonBuiltin CallableSymbolicExpressionRing banner coth Morphism 
  syn keyword pythonBuiltin crt quit_sage cached_function J0 J1 dilog 
  syn keyword pythonBuiltin integral_numerical Polynomial gilbert_lower_bound 
  syn keyword pythonBuiltin is_Vector unpickle_instantiate seq fast_callable 
  syn keyword pythonBuiltin multiplicative_order Dokchitser ClassicalCrystals 
  syn keyword pythonBuiltin sec PartitionsGreatestEQ arg DeBruijnSequences 
  syn keyword pythonBuiltin is_PowerSeries moving_average lisp_console 
  syn keyword pythonBuiltin SetPartitionsTk partition_sandpile IntegerListsLex 
  syn keyword pythonBuiltin MacdonaldPolynomialsS MacdonaldPolynomialsQ 
  syn keyword pythonBuiltin MacdonaldPolynomialsP r_console eulers_method_2x2 
  syn keyword pythonBuiltin EllipticCurve_from_cubic Cylindrical is_RealNumber 
  syn keyword pythonBuiltin MacdonaldPolynomialsJ MacdonaldPolynomialsH 
  syn keyword pythonBuiltin old_cremona_letter_code MixedIntegerLinearProgram 
  syn keyword pythonBuiltin interfaces BCHCode CubicalComplex license 
  syn keyword pythonBuiltin PermutationOptions gaunt SAGE_URL 
  syn keyword pythonBuiltin least_quadratic_nonresidue DOT_SAGE 
  syn keyword pythonBuiltin spherical_hankel1 gap3_version load GroupAlgebras 
  syn keyword pythonBuiltin sinh matlab_console is_AffineSpace matlab_version 
  syn keyword pythonBuiltin zeta is_PolynomialQuotientRing RestrictedPartitions 
  syn keyword pythonBuiltin discriminant is_ComplexField PariGroup 
  syn keyword pythonBuiltin volume_hamming pg kronecker numerical_approx pi 
  syn keyword pythonBuiltin is_iterator asinh FanMorphism load_attach_mode imag 
  syn keyword pythonBuiltin Newform numerical_sqrt NumberFields unpickle_build 
  syn keyword pythonBuiltin HammingCode polygon_spline tetrahedron 
  syn keyword pythonBuiltin cached_in_parent_method nth_prime 
  syn keyword pythonBuiltin enumerate_totallyreal_fields_all ForgetfulFunctor 
  syn keyword pythonBuiltin PerfectMatching srange sage_wraps IntegerModRing 
  syn keyword pythonBuiltin free_module_element CombinatorialSpecies 
  syn keyword pythonBuiltin InfinitePolynomialRing allocatemem 
  syn keyword pythonBuiltin is_RealDoubleElement Gap3 copying 
  syn keyword pythonBuiltin continued_fraction_list IntegralDomain TestSuite 
  syn keyword pythonBuiltin inject_on DynkinDiagram is_Graphics class_graph 
  syn keyword pythonBuiltin save_session SimplicialComplex WeylGroups 
  syn keyword pythonBuiltin is_FreeMonoid sageobj hecke_operator_on_basis 
  syn keyword pythonBuiltin QuadraticBernoulliNumber QuadraticResidueCode 
  syn keyword pythonBuiltin is_Matrix SymbolicData LaurentPolynomialRing Matrix 
  syn keyword pythonBuiltin is_Category RootSystem is_OctalStringMonoidElement 
  syn keyword pythonBuiltin qepcad_console is_2_adic_genus 
  syn keyword pythonBuiltin NonNegativeIntegerSemiring desolve zeta_zeros 
  syn keyword pythonBuiltin jacobian igusa_clebsch_invariants 
  syn keyword pythonBuiltin PermutationGroup_generic catalan 
  syn keyword pythonBuiltin bounds_minimum_distance kash KleinFourGroup 
  syn keyword pythonBuiltin SetPartitions integer gap_version 
  syn keyword pythonBuiltin EllipticCurves_with_good_reduction_outside_S Gamma1 
  syn keyword pythonBuiltin FiniteSetMaps AffineToricVariety CoalgebrasWithBasis 
  syn keyword pythonBuiltin LaurentSeriesRing Spline ModularSymbols 
  syn keyword pythonBuiltin WeightedIntegerVectors AbelianStrata polygon2d 
  syn keyword pythonBuiltin Algebras EllipticCurve is_Element expnums 
  syn keyword pythonBuiltin genus2reduction Complexes Simplex prod 
  syn keyword pythonBuiltin buzzard_tpslopes O theta_qexp 
  syn keyword pythonBuiltin is_AbelianGroupMorphism LyndonWord Permutation 
  syn keyword pythonBuiltin is_PrimeField aztec_sandpile hurwitz_zeta 
  syn keyword pythonBuiltin FiniteSemigroups bezier_path is_RealIntervalField 
  syn keyword pythonBuiltin identity_matrix NumberField kSchurFunctions asech 
  syn keyword pythonBuiltin gamma AbelianGroup_subgroup arcsinh integral 
  syn keyword pythonBuiltin kronecker_symbol HighestWeightCrystal is_NumberField 
  syn keyword pythonBuiltin is_PrincipalIdealDomain DiscreteRandomVariable 
  syn keyword pythonBuiltin enumerate_totallyreal_fields_rel ellipse DLXMatrix 
  syn keyword pythonBuiltin span cached_method is_PrimeFiniteField brun 
  syn keyword pythonBuiltin gp_console is_AdditiveGroupElement NormalFan gauss 
  syn keyword pythonBuiltin ClassFunction dynkin_diagram line is_power_of_two 
  syn keyword pythonBuiltin RationalField parallel_firing_graph is_R_algebra 
  syn keyword pythonBuiltin euler_gamma _oh is_EuclideanDomainElement 
  syn keyword pythonBuiltin betavariate dirac_delta lazy_class_attribute 
  syn keyword pythonBuiltin WeylCharacterRing TransitiveIdealGraded 
  syn keyword pythonBuiltin AdditiveMagmas LeftModules FreeModule Mat gnuplot 
  syn keyword pythonBuiltin FiniteGroups delta_lseries objgens Kash 
  syn keyword pythonBuiltin is_MatrixGroupElement AA RingIdeals mwrank_console 
  syn keyword pythonBuiltin SQLQuery SandpileDivisor CyclicCode 
  syn keyword pythonBuiltin ExtendedQuadraticResidueCode asec inject_off sudoku 
  syn keyword pythonBuiltin e Sequence Tachyon StandardSkewTableaux polygon3d 
  syn keyword pythonBuiltin kronecker_character_upside_down CuspFamily ZqFM 
  syn keyword pythonBuiltin Ribbon zeta__exact SymmetricGroupAlgebra gp 
  syn keyword pythonBuiltin AtkinModularCorrespondenceDatabase 
  syn keyword pythonBuiltin hilbert_class_polynomial VectorSpace Bialgebras 
  syn keyword pythonBuiltin griesmer_upper_bound SL2Z LLT cython compose 
  syn keyword pythonBuiltin parametric_plot3d Parent partition_associated 
  syn keyword pythonBuiltin hg_scripts LinearCode FreeQuadraticModule Bitset 
  syn keyword pythonBuiltin Words exit is_PermutationGroupMorphism 
  syn keyword pythonBuiltin is_DiscreteRandomVariable mrange_iter trial_division 
  syn keyword pythonBuiltin deprecation PointedSets RealDistribution wave 
  syn keyword pythonBuiltin SuzukiGroup AffineHypersurface elliptic_kc 
  syn keyword pythonBuiltin RightModules IntegralDomainElement previous_prime 
  syn keyword pythonBuiltin FFT SupersingularModule is_MaximaElement _i13 _i12 
  syn keyword pythonBuiltin _i11 _i10 _i17 _i16 _i15 _i14 _i19 _i18 randrange 
  syn keyword pythonBuiltin find_minimum_on_interval SymbolicLogic 
  syn keyword pythonBuiltin RibbonTableaux logstr AbelianGroup gen_laguerre 
  syn keyword pythonBuiltin BackslashOperator ComplexField 
  syn keyword pythonBuiltin find_maximum_on_interval random_tree log_dvi 
  syn keyword pythonBuiltin magma_version browse_sage_doc BinaryQF tmp_dir 
  syn keyword pythonBuiltin implicit_multiplication multinomial octave 
  syn keyword pythonBuiltin is_FractionFieldElement is_PolynomialRing 
  syn keyword pythonBuiltin FractionField Mwrank maple_console gens 
  syn keyword pythonBuiltin self_dual_codes_binary is_LaurentSeriesRing qepcad 
  syn keyword pythonBuiltin Category sgn SimplicialComplexes j_invariant_qexp 
  syn keyword pythonBuiltin number_of_partitions_list eisenstein_series_qexp 
  syn keyword pythonBuiltin partition_power pari_gen CommutativeRingElement 
  syn keyword pythonBuiltin EmptySetError Integers permutations mupad_console 
  syn keyword pythonBuiltin is_RingHomomorphism benchmark chebyshev_U 
  syn keyword pythonBuiltin chebyshev_T ModuleElement xlcm FreeAbelianMonoid 
  syn keyword pythonBuiltin is_odd CyclicPermutationGroup proof wedge RealField 
  syn keyword pythonBuiltin Radix64Strings WeylGroup assumptions is_Monoid QqCR 
  syn keyword pythonBuiltin deepcopy tan Composition best_known_linear_code_www 
  syn keyword pythonBuiltin gcd SetPartitionsPRk FreeModules 
  syn keyword pythonBuiltin half_integral_weight_modform_basis dickman_rho 
  syn keyword pythonBuiltin linear_program GradedBialgebras order_from_multiple 
  syn keyword pythonBuiltin grid_sandpile singular SQLDatabase notebook 
  syn keyword pythonBuiltin PositiveIntegers partition_sign LatinSquare 
  syn keyword pythonBuiltin PermutationGroupMorphism_id Arrangements ChainPoset 
  syn keyword pythonBuiltin experimental_packages is_RingHomset SandpileConfig 
  syn keyword pythonBuiltin sort_complex_numbers_for_display elias_upper_bound 
  syn keyword pythonBuiltin mqrr_rational_reconstruction SetPartitionsSk ln csch 
  syn keyword pythonBuiltin LatexExpr moebius derivative Maxima 
  syn keyword pythonBuiltin CyclicCodeFromGeneratingPolynomial factorial 
  syn keyword pythonBuiltin bernoulli standard_packages toric_plotter 
  syn keyword pythonBuiltin Gamma0_NFCusps SetsWithPartialMaps revolution_plot3d 
  syn keyword pythonBuiltin trac edit sin _16 running_total _13 mode _11 
  syn keyword pythonBuiltin EllipticCurve_from_j monomials _18 current_randstate 
  syn keyword pythonBuiltin DedekindEtaModularPolynomialDatabase 
  syn keyword pythonBuiltin ClassicalCrystalOfAlcovePathsElement category 
  syn keyword pythonBuiltin PrincipalIdealDomains matrix gammavariate ZpCA 
  syn keyword pythonBuiltin FormalSum NilCoxeterAlgebra _i26 _i24 _i25 _i22 ZpCR 
  syn keyword pythonBuiltin _i20 _i21 find_fit localvars is_RationalField 
  syn keyword pythonBuiltin octave_console repr_lincomb quo mwrank_EllipticCurve 
  syn keyword pythonBuiltin db_save map_threaded Subwords lattice_polytope 
  syn keyword pythonBuiltin BinaryStrings hermite_constant parallel 
  syn keyword pythonBuiltin canonical_coercion ordered_partitions Gfan XGCD 
  syn keyword pythonBuiltin OrderedMonoids search_def is_FieldElement Frac 
  syn keyword pythonBuiltin sagenb all_max_clique PartiallyOrderedSets attach 
  syn keyword pythonBuiltin companion_matrix MatrixAlgebras posets 
  syn keyword pythonBuiltin SymmetricGroupBruhatOrderPoset exp_int slider R 
  syn keyword pythonBuiltin arctanh discrete_log algebraic_dependency 
  syn keyword pythonBuiltin binomial_coefficients RubiksCube BinaryGolayCode 
  syn keyword pythonBuiltin AlternatingGroup is_AlgebraicNumber _iii arc 
  syn keyword pythonBuiltin prime_to_m_part preparser false sage_eval _i9 _i8 
  syn keyword pythonBuiltin _i7 _i6 PolynomialRing _i4 _i3 _i2 _i1 Graphics 
  syn keyword pythonBuiltin designs_from_XML number_of_partitions_set 
  syn keyword pythonBuiltin AlgebraicNumber is_FreeAbelianMonoid TimeSeries 
  syn keyword pythonBuiltin is_PrincipalIdealDomainElement RandomLinearCode 
  syn keyword pythonBuiltin lazy_attribute quadratic_L_function__exact 
  syn keyword pythonBuiltin minimal_polynomial desolve_odeint HomsetWithBase _ip 
  syn keyword pythonBuiltin is_pAdicRing graphs FreeMonoid _ih discrete_log_rho 
  syn keyword pythonBuiltin is_AffineScheme number_of_partitions_tuples 
  syn keyword pythonBuiltin graphs_list UnorderedTuples text 
  syn keyword pythonBuiltin IwahoriHeckeAlgebraT Pari MacdonaldPolynomialsHt 
  syn keyword pythonBuiltin local_print_mode AdditiveAbelianGroup 
  syn keyword pythonBuiltin BezoutianQuadraticForm AffineWeylGroups 
  syn keyword pythonBuiltin LazyPowerSeriesRing delta_complexes 
  syn keyword pythonBuiltin HilbertClassPolynomialDatabase is_MatrixGroup 
  syn keyword pythonBuiltin bell_number Mod cube GenericGraphQuery wigner_6j 
  syn keyword pythonBuiltin words number_of_unordered_tuples desolve_system_rk4 
  syn keyword pythonBuiltin numerical_integral AbelianGroupMorphism 
  syn keyword pythonBuiltin inverse_jacobi AlphabeticStrings is_DualAbelianGroup 
  syn keyword pythonBuiltin schonheim CRT gamma__exact victor_miller_basis 
  syn keyword pythonBuiltin charpoly FiniteCombinatorialClass arrow3d MSymbol 
  syn keyword pythonBuiltin stats optional_packages MathieuGroup is_FiniteField 
  syn keyword pythonBuiltin email PermutationGroupMorphism WeylDim qsieve 
  syn keyword pythonBuiltin next_prime_power transpose 
  syn keyword pythonBuiltin FiniteDimensionalAlgebrasWithBasis 
  syn keyword pythonBuiltin HyperellipticCurve SignedCompositions Homset 
  syn keyword pythonBuiltin RealInterval singleton_bound_asymp 
  syn keyword pythonBuiltin EllipticCurveIsogeny cm_j_invariants eta 
  syn keyword pythonBuiltin is_SingularElement forall tachyon_rt LCM 
  syn keyword pythonBuiltin IntegerVectors SFAMonomial mrrw1_bound_asymp 
  syn keyword pythonBuiltin is_QuadraticField quit pAdicWeightSpace piecewise 
  syn keyword pythonBuiltin inotebook xsrange CommutativeRing 
  syn keyword pythonBuiltin RandomLinearCodeGuava ClonableIntArray IntegerRing 
  syn keyword pythonBuiltin Hom cos spherical_bessel_J 
  syn keyword pythonBuiltin is_Radix64StringMonoidElement 
  syn keyword pythonBuiltin CyclicSievingPolynomial is_PowerSeriesRing 
  syn keyword pythonBuiltin spherical_bessel_Y CDF subsets TransitiveIdeal 
  syn keyword pythonBuiltin linear_transformation default_mip_solver 
  syn keyword pythonBuiltin self_compose initial_seed Necklaces arrangements 
  syn keyword pythonBuiltin Reals Sandpile pAdicExtension unpickle_appends sqrt 
  syn keyword pythonBuiltin __package__ units is_ExpectElement get_verbose_files 
  syn keyword pythonBuiltin infinity integral_closure r_version khinchin 
  syn keyword pythonBuiltin CartanType variance TransitiveGroups FiniteMonoids 
  syn keyword pythonBuiltin spherical_hankel2 expand DualAbelianGroupElement 
  syn keyword pythonBuiltin KummerSurface Algebra list_composition 
  syn keyword pythonBuiltin StandardTableaux is_IntegerModRing 
  syn keyword pythonBuiltin dimension_upper_bound plotkin_upper_bound 
  syn keyword pythonBuiltin PermutationGroup BipartiteGraph restore 
  syn keyword pythonBuiltin mwrank_initprimes ultraspherical QuotientRing 
  syn keyword pythonBuiltin is_pseudoprime_small_power is_Set PSage 
  syn keyword pythonBuiltin addition_names is_BinaryStringMonoidElement point 
  syn keyword pythonBuiltin ZqCR sage0 bezier3d add Fan ag_code Compositions 
  syn keyword pythonBuiltin ZqCA tests text_control HexadecimalStrings 
  syn keyword pythonBuiltin BooleanLattice sagex InteractiveShell subfactorial 
  syn keyword pythonBuiltin monsky_washnitzer ConwayPolynomials 
  syn keyword pythonBuiltin is_CommutativeAlgebraElement 
  syn keyword pythonBuiltin DedekindEtaModularCorrespondenceDatabase glaisher 
  syn keyword pythonBuiltin is_Field arccsch VigenereCryptosystem WalshCode 
  syn keyword pythonBuiltin list_plot gnuplot_console zero_vector 
  syn keyword pythonBuiltin admissible_partitions lognormvariate 
  syn keyword pythonBuiltin QuadraticStratum DedekindDomainElement _10 imaginary 
  syn keyword pythonBuiltin diagonal_matrix jordan_block minimize_constrained 
  syn keyword pythonBuiltin NFCusps four_squares Crystals ToricCode 
  syn keyword pythonBuiltin CommutativeRings implicit_plot Graph 
  syn keyword pythonBuiltin AlgebraicRealField sloane_sequence arrow2d 
  syn keyword pythonBuiltin exists_conway_polynomial is_Ring var PowComputer 
  syn keyword pythonBuiltin is_fundamental_discriminant eratosthenes function 
  syn keyword pythonBuiltin Groups BlockDesign_generic ClonableElement 
  syn keyword pythonBuiltin absolute_igusa_invariants_wamelen valuation 
  syn keyword pythonBuiltin graph_editor is_ModularFormElement 
  syn keyword pythonBuiltin lfsr_connection_polynomial linear_relation 
  syn keyword pythonBuiltin CoordinatePatch FiniteCrystals sage0_console limit 
  syn keyword pythonBuiltin QQbar ModularSymbols_clear_cache axiom_console CIF 
  syn keyword pythonBuiltin fricas_console EtaGroup_class Rationals 
  syn keyword pythonBuiltin PermutationGroup_subgroup HighestWeightCrystals 
  syn keyword pythonBuiltin CommutativeAdditiveMonoids 
  syn keyword pythonBuiltin FiniteDimensionalBialgebrasWithBasis arctan 
  syn keyword pythonBuiltin is_triangular_number desolve_laplace pad_zeros 
  syn keyword pythonBuiltin contour_plot gap_reset_workspace mertens 
  syn keyword pythonBuiltin CommutativeRingIdeals PowerSeriesRing DWT 
  syn keyword pythonBuiltin is_ComplexIntervalField bell_polynomial 
  syn keyword pythonBuiltin BinaryReedMullerCode best_known_linear_code N 
  syn keyword pythonBuiltin ArithmeticSubgroup_Permutation is_AlgebraicReal 
  syn keyword pythonBuiltin cylindrical_plot3d is_64_bit GradedCoalgebras Maple 
  syn keyword pythonBuiltin AllExactCovers ellipsis_range KodairaSymbol
endif

" From the 'Python Library Reference' class hierarchy at the bottom.
" http://docs.python.org/library/exceptions.html
if !exists("python_no_exception_highlight")
  " builtin base exceptions (only used as base classes for other exceptions)
  syn keyword pythonExceptions	BaseException Exception
  syn keyword pythonExceptions	ArithmeticError EnvironmentError
  syn keyword pythonExceptions	LookupError
  " builtin base exception removed in Python 3.0
  syn keyword pythonExceptions	StandardError
  " builtin exceptions (actually raised)
  syn keyword pythonExceptions	AssertionError AttributeError BufferError
  syn keyword pythonExceptions	EOFError FloatingPointError GeneratorExit
  syn keyword pythonExceptions	IOError ImportError IndentationError
  syn keyword pythonExceptions	IndexError KeyError KeyboardInterrupt
  syn keyword pythonExceptions	MemoryError NameError NotImplementedError
  syn keyword pythonExceptions	OSError OverflowError ReferenceError
  syn keyword pythonExceptions	RuntimeError StopIteration SyntaxError
  syn keyword pythonExceptions	SystemError SystemExit TabError TypeError
  syn keyword pythonExceptions	UnboundLocalError UnicodeError
  syn keyword pythonExceptions	UnicodeDecodeError UnicodeEncodeError
  syn keyword pythonExceptions	UnicodeTranslateError ValueError VMSError
  syn keyword pythonExceptions	WindowsError ZeroDivisionError
  " builtin warnings
  syn keyword pythonExceptions	BytesWarning DeprecationWarning FutureWarning
  syn keyword pythonExceptions	ImportWarning PendingDeprecationWarning
  syn keyword pythonExceptions	RuntimeWarning SyntaxWarning UnicodeWarning
  syn keyword pythonExceptions	UserWarning Warning
endif

if exists("python_space_error_highlight")
  " trailing whitespace
  syn match   pythonSpaceError	display excludenl "\s\+$"
  " mixed tabs and spaces
  syn match   pythonSpaceError	display " \+\t"
  syn match   pythonSpaceError	display "\t\+ "
endif

" Do not spell doctests inside strings.
" Notice that the end of a string, either ''', or """, will end the contained
" doctest too.  Thus, we do *not* need to have it as an end pattern.
if !exists("python_no_doctest_highlight")
  if !exists("python_no_doctest_code_higlight")
    syn region pythonDoctest
	  \ start="^\s*>>>\s" end="^\s*$"
	  \ contained contains=ALLBUT,pythonDoctest,@Spell
    syn region pythonDoctestValue
	  \ start=+^\s*\%(>>>\s\|\.\.\.\s\|"""\|'''\)\@!\S\++ end="$"
	  \ contained
  else
    syn region pythonDoctest
	  \ start="^\s*>>>" end="^\s*$"
	  \ contained contains=@NoSpell
  endif
endif

" Sync at the beginning of class, function, or method definition.
syn sync match pythonSync grouphere NONE "^\s*\%(def\|class\)\s\+\h\w*\s*("

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default highlight links.  Can be overridden later.
  HiLink pythonStatement	Statement
  HiLink pythonConditional	Conditional
  HiLink pythonRepeat		Repeat
  HiLink pythonOperator		Operator
  HiLink pythonException	Exception
  HiLink pythonInclude		Include
  HiLink pythonDecorator	Define
  HiLink pythonFunction		Function
  HiLink pythonComment		Comment
  HiLink pythonTodo		Todo
  HiLink pythonString		String
  HiLink pythonRawString	String
  HiLink pythonEscape		Special
  if !exists("python_no_number_highlight")
    HiLink pythonNumber		Number
  endif
  if !exists("python_no_builtin_highlight")
    HiLink pythonBuiltin	Function
  endif
  if !exists("python_no_exception_highlight")
    HiLink pythonExceptions	Structure
  endif
  if exists("python_space_error_highlight")
    HiLink pythonSpaceError	Error
  endif
  if !exists("python_no_doctest_highlight")
    HiLink pythonDoctest	Special
    HiLink pythonDoctestValue	Define
  endif

  delcommand HiLink
endif

let b:current_syntax = "python"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2 ts=8 noet:
