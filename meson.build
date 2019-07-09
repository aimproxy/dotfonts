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

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())

subdir('data')
subdir('src')

dependencies = [
	dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('granite'),
  dependency('gtk+-3.0'),
  dependency('json-glib-1.0'),
  dependency('libsoup-2.4'),
  meson.get_compiler('vala').find_library('posix'),
]

e = executable('com.github.aimproxy.dotfonts',
    sources,
    gresource,
    dependencies: dependencies,
    install : true
)

meson.add_install_script('meson/post_install.py')
