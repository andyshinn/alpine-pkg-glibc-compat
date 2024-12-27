# Maintainer: Sasha Gerrand <alpine-pkgs@sgerrand.com>

pkgname="glibc"
pkgver="2.39"
pkgrel="1"
pkgdesc="GNU C Library compatibility layer"
arch="aarch64"
url="https://github.com/sgerrand/alpine-pkg-glibc"
license="LGPL"
source="./glibc-bin-$pkgver.tar.gz
ld.so.conf"
subpackages="$pkgname-bin $pkgname-dev $pkgname-i18n"
triggers="$pkgname-bin.trigger=/lib:/usr/lib:/usr/glibc-compat/lib"

package() {
  mkdir -p "$pkgdir/lib" "$pkgdir/usr/glibc-compat/lib/locale" "$pkgdir"/usr/glibc-compat/lib64 "$pkgdir"/etc
  cp -a "$srcdir"/usr "$pkgdir"
  cp "$srcdir"/ld.so.conf "$pkgdir"/usr/glibc-compat/etc/ld.so.conf
  rm "$pkgdir"/usr/glibc-compat/etc/rpc
  rm -rf "$pkgdir"/usr/glibc-compat/bin
  rm -rf "$pkgdir"/usr/glibc-compat/sbin
  rm -rf "$pkgdir"/usr/glibc-compat/lib/gconv
  rm -rf "$pkgdir"/usr/glibc-compat/lib/getconf
  rm -rf "$pkgdir"/usr/glibc-compat/lib/audit
  rm -rf "$pkgdir"/usr/glibc-compat/share
  rm -rf "$pkgdir"/usr/glibc-compat/var

  # 根据架构设置符号链接
  case "$arch" in
  x86_64)
    ln -s /usr/glibc-compat/lib/ld-linux-x86_64.so.2 ${pkgdir}/lib/ld-linux-x86_64.so.2
    ln -s /usr/glibc-compat/lib/ld-linux-x86_64.so.2 ${pkgdir}/usr/glibc-compat/lib64/ld-linux-x86_64.so.2
    ;;
  aarch64)
    ln -s /usr/glibc-compat/lib/ld-linux-aarch64.so.1 ${pkgdir}/lib/ld-linux-aarch64.so.1
    ln -s /usr/glibc-compat/lib/ld-linux-aarch64.so.1 ${pkgdir}/usr/glibc-compat/lib64/ld-linux-aarch64.so.1
    ;;
  *)
    echo "not support: $arch"
    exit 1
    ;;
  esac

  ln -s /usr/glibc-compat/etc/ld.so.cache ${pkgdir}/etc/ld.so.cache
}

bin() {
  depends="$pkgname bash libc6-compat libgcc"
  mkdir -p "$subpkgdir"/usr/glibc-compat
  cp -a "$srcdir"/usr/glibc-compat/bin "$subpkgdir"/usr/glibc-compat
  cp -a "$srcdir"/usr/glibc-compat/sbin "$subpkgdir"/usr/glibc-compat
}

i18n() {
  depends="$pkgname-bin"
  arch="noarch"
  mkdir -p "$subpkgdir"/usr/glibc-compat
  cp -a "$srcdir"/usr/glibc-compat/share "$subpkgdir"/usr/glibc-compat
}
