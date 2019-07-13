project('com.github.aimproxy.dotfonts', ['vala', 'c'],
    version : '0.1.0',
    license: 'GPL-3.0'
)

add_project_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
    ],
    language: 'c',
)

gnome = import('gnome')
i18n = import('i18n')

gresource = gnome.compile_resources(
    'as-resources', 'data/com.github.aimproxy.dotfonts.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())
conf_data.set_quoted('PREFIX', get_option('prefix'))

sources = files()

subdir('data')
subdir('src')

dependencies = [
	dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('granite'),
  dependency('gtk+-3.0'),
  dependency('json-glib-1.0'),
  dependency('libsoup-2.4'),
  dependency('gtksourceview-3.0'),
  meson.get_compiler('vala').find_library('posix'),
]

vala_lint = find_program('io.elementary.vala-lint', required : false)
if vala_lint.found()
    test (
        'Vala lint',
        vala_lint,
        args: ['-d', join_paths(meson.source_root(), 'src')]
    )
endif

e = executable('com.github.aimproxy.dotfonts',
    sources,
    gresource,
    dependencies: dependencies,
    install : true
)

meson.add_install_script('meson/post_install.py')
