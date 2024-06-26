cpp = meson.get_compiler('cpp')
qt5_dep = dependency('qt5', modules: ['Qml', 'Quick', 'Gui'])
dep_wayland_client = dependency('wayland-client', version: '>= 1.20.0')
dep_qtappfw = [
    dependency('qtappfw-weather'),
    dependency('qtappfw-network'),
    dependency('qtappfw-bt'),
    dependency('qtappfw-vehicle-signals'),
    dependency('qtappfw-applauncher')
]

grpcpp_reflection_dep = cpp.find_library('grpc++_reflection')
protoc = find_program('protoc')
grpc_cpp = find_program('grpc_cpp_plugin')

qt_defines = []
qpa_header_path = join_paths(qt5_dep.version(), 'QtGui')
qpa_header = join_paths(qpa_header_path, 'qpa/qplatformnativeinterface.h')
# we pass this QT_QPA_HEADER straight in the code as there's no easy
# way to pass the correct header
if cpp.has_header(qpa_header, dependencies : qt5_dep)
  qt_defines += [ '-DQT_QPA_HEADER=<@0@>'.format(qpa_header) ]
  message('Found QtGui QPA header in ' + qpa_header_path)
endif

dep_scanner = dependency('wayland-scanner')
prog_scanner = find_program('wayland-scanner')
agl_compositor_version = '0.0.24'
agl_compositor_dep = dependency('agl-compositor-' + agl_compositor_version + '-protocols')
dir_agl_compositor_base = agl_compositor_dep.get_variable(pkgconfig: 'pkgdatadir')

protoc_gen = generator(protoc, \
                       output : ['@BASENAME@.pb.cc', '@BASENAME@.pb.h'],
                       arguments : ['--proto_path=@CURRENT_SOURCE_DIR@/proto',
                         '--cpp_out=@BUILD_DIR@',
                         '@INPUT@'])

generated_protoc_sources = protoc_gen.process('proto/agl_shell.proto')

grpc_gen = generator(protoc, \
                     output : ['@BASENAME@.grpc.pb.cc', '@BASENAME@.grpc.pb.h'],
                     arguments : ['--proto_path=@CURRENT_SOURCE_DIR@/proto',
                       '--grpc_out=@BUILD_DIR@',
                       '--plugin=protoc-gen-grpc=' + grpc_cpp.path(),
                       '@INPUT@'])
generated_grpc_sources = grpc_gen.process('proto/agl_shell.proto')

grpc_deps = [
    dependency('protobuf'),
    dependency('grpc'),
    dependency('grpc++'),
    grpcpp_reflection_dep,
]


homescreen_dep = [
    qt5_dep,
    dep_wayland_client,
    dep_qtappfw,
    grpc_deps
]

homescreen_resources = [
  'qml/images/MediaPlayer/mediaplayer.qrc',
  'qml/images/MediaMusic/mediamusic.qrc',
  'qml/images/Weather/weather.qrc',
  'qml/images/Shortcut/shortcut.qrc',
  'qml/images/Status/status.qrc',
  'qml/images/images.qrc',
  'qml/qml.qrc'
]

resource_files = qt5.compile_resources(sources: homescreen_resources)

protocols = [
        [ 'agl-shell', 'agl-compositor' ],
]

foreach proto: protocols
        proto_name = proto[0]
        if proto[1] == 'agl-compositor'
                base_file = proto_name
                xml_path = join_paths(dir_agl_compositor_base, '@0@.xml'.format(base_file))
        endif

        foreach output_type: [ 'client-header', 'server-header', 'private-code' ]
                if output_type == 'client-header'
                        output_file = '@0@-client-protocol.h'.format(base_file)
                elif output_type == 'server-header'
                        output_file = '@0@-server-protocol.h'.format(base_file)
                else
                        output_file = '@0@-protocol.c'.format(base_file)
                        if dep_scanner.version().version_compare('< 1.14.91')
                                output_type = 'code'
                        endif
                endif

                var_name = output_file.underscorify()
                target = custom_target(
                        '@0@ @1@'.format(base_file, output_type),
                        command: [ prog_scanner, output_type, '@INPUT@', '@OUTPUT@' ],
                        input: xml_path,
                        output: output_file,
                )
                message('protocol name is ' + var_name)
                set_variable(var_name, target)
        endforeach
endforeach

homescreen_src_headers = [
  'src/applicationlauncher.h',
  'src/mastervolume.h',
  'src/statusbarmodel.h',
  'src/statusbarserver.h',
  'src/homescreenhandler.h',
  'src/AglShellGrpcClient.h',
]

moc_files = qt5.compile_moc(headers: homescreen_src_headers,
                            dependencies: qt5_dep)

homescreen_src = [
  'src/statusbarserver.cpp',
  'src/statusbarmodel.cpp',
  'src/applicationlauncher.cpp',
  'src/mastervolume.cpp',
  'src/homescreenhandler.cpp',
  'src/AglShellGrpcClient.cpp',
  'src/main.cpp',
  agl_shell_client_protocol_h,
  agl_shell_protocol_c,
  generated_protoc_sources,
  generated_grpc_sources
]

executable('homescreen', homescreen_src, resource_files, moc_files,
            cpp_args: qt_defines,
            dependencies : homescreen_dep,
            install: true)
