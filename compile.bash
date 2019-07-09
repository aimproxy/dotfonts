if [ -d "build" ]; then
	sudo rm -rf build/
fi

meson build --prefix=/usr
cd build/
sudo ninja install
cd ..
