%define version _VERSION_
Name:           sif
Version:        %{version}
Release:        1%{?dist}
Summary:        SIF is a simple Python script allowing you to fix runtime icons of Steam games displayed in dock or panel to match Linux system icon theme.

License:        ASL 2.0
URL:            https://github.com/BlueManCZ/SIF
Source0:        https://github.com/Chapien/sif-rpm/raw/refs/heads/main/SOURCES/sif-%{version}.tar.gz

BuildRequires:  python3-devel
Requires:       python3dist(PyGObject)
Requires:       python3dist(requests)
Requires:       python3dist(vdf)
Requires:       xdotool

BuildArch:      noarch

%description
SIF is a simple Python script allowing you to fix runtime icons of Steam games displayed in dock or panel to match Linux system icon theme.

%prep
%setup -q

%install
mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/%{_datadir}
mkdir -p %{buildroot}/%{_datadir}/%{name}
%py3_shebang_fix sif.py
install -m 0755 sif.py %{buildroot}%{_datadir}/%{name}/sif.py
install -m 0755 fix-wm-class.sh %{buildroot}%{_datadir}/%{name}/fix-wm-class.sh
install -m 0644 database.json %{buildroot}%{_datadir}/%{name}/database.json
ln -sf %{_datadir}/%{name}/sif.py sif
mv sif %{buildroot}%{_bindir}/sif

%files
%license LICENSE
%doc README.md
%{_datadir}/%{name}/sif.py
%{_datadir}/%{name}/fix-wm-class.sh
%{_datadir}/%{name}/database.json
%{_bindir}/sif

%changelog
* Tue Jun 03 2025 Chapien <inquiries@chapien.net>
- 
