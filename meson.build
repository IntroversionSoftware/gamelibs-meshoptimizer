project('meshoptimizer', 'cpp', version: '0.16')

incdirs = ['src']

sources = [
	'src/allocator.cpp',
	'src/clusterizer.cpp',
	'src/indexcodec.cpp',
	'src/indexgenerator.cpp',
	'src/overdrawanalyzer.cpp',
	'src/overdrawoptimizer.cpp',
	'src/simplifier.cpp',
	'src/spatialorder.cpp',
	'src/stripifier.cpp',
	'src/vcacheanalyzer.cpp',
	'src/vcacheoptimizer.cpp',
	'src/vertexcodec.cpp',
	'src/vertexfilter.cpp',
	'src/vfetchanalyzer.cpp',
	'src/vfetchoptimizer.cpp',
]

incdirs = include_directories(incdirs)

lib = static_library(
    'meshoptimizer',
    sources,
    include_directories: incdirs,
)

meshoptimizer_dep = declare_dependency(
    include_directories: incdirs,
    link_with: lib,
    version: meson.project_version()
)

meson.override_dependency('meshoptimizer', meshoptimizer_dep)

# vim: set ts=4 sts=4 sw=4 et:
