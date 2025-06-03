%define version 163
Name:           sif
Version:        %{version}
Release:        1%{?dist}
Summary:        RPM package for Steam Icon Fixer.

License:        ASL 2.0
URL:            https://github.com/Chapien/sif-rpm/raw/refs/heads/main/SOURCES/sif-%{version}.tar.gz
Source0:        sif-%{version}.tar.gz

Requires:       python3
Requires:       python3-gobject
Requires:       python3-requests
Requires:       python3-vdf
Requires:       xdotool
Requires:       bash

BuildArch:      noarch

%description
Steam Icon Fixer.

%prep
%setup -q

%install
mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/%{_datadir}
mkdir -p %{buildroot}/%{_datadir}/%{name}
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
