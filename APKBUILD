# Maintainer: Sasha Gerrand <alpine-pkgs@sgerrand.com>

pkgname="glibc"
pkgver="2.35"
_pkgrel="0"
pkgrel="1"
pkgdesc="GNU C Library compatibility layer"
options="lib64"
arch="x86_64"
url="https://github.com/sgerrand/alpine-pkg-glibc"
license="LGPL"
source="https://github.com/sgerrand/docker-glibc-builder/releases/download/$pkgver-$_pkgrel/glibc-bin-$pkgver-$_pkgrel-x86_64.tar.gz
ld.so.conf"
subpackages="$pkgname-bin $pkgname-utils $pkgname-dev $pkgname-i18n"
triggers="$pkgname-bin.trigger=/lib:/usr/lib:/usr/glibc-compat/lib"

package() {
  provides="libc6-compat"
  conflicts="libc6-compat"
  mkdir -p "$pkgdir/lib" "$pkgdir/lib64" "$pkgdir/usr/glibc-compat/lib/locale"  "$pkgdir"/usr/glibc-compat/lib64 "$pkgdir"/etc
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
  ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 ${pkgdir}/lib/ld-linux-x86-64.so.2
  ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 ${pkgdir}/lib64/ld-linux-x86-64.so.2
  ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 ${pkgdir}/usr/glibc-compat/lib64/ld-linux-x86-64.so.2
  ln -s /usr/glibc-compat/etc/ld.so.cache ${pkgdir}/etc/ld.so.cache
}

bin() {
  pkgdesc="executable programs that come with glibc, installed to /usr/glibc-compat/"
  depends="$pkgname libgcc"
  depends="$depends bash" # shebang for ldd, sotrus, tzselect, xtrace
  depends="$depends perl" # shebang for mtrace
  mkdir -p "$subpkgdir"/usr/glibc-compat
  cp -a "$srcdir"/usr/glibc-compat/bin "$subpkgdir"/usr/glibc-compat
  cp -a "$srcdir"/usr/glibc-compat/sbin "$subpkgdir"/usr/glibc-compat
}

utils() {
  pkgdesc="a replacement for musl-utils that uses the glibc versions of those utilities"
  depends="$pkgname-bin"
  provides="musl-utils"
  conflicts="musl-utils"
  mkdir -p "$subpkgdir"/usr/bin "$subpkgdir"/usr/sbin
  ln -s /usr/glibc-compat/bin/getconf   "$subpkgdir"/usr/bin
  ln -s /usr/glibc-compat/bin/getent    "$subpkgdir"/usr/bin
  ln -s /usr/glibc-compat/bin/iconv     "$subpkgdir"/usr/bin
  ln -s /usr/glibc-compat/bin/ldd       "$subpkgdir"/usr/bin
  ln -s /usr/glibc-compat/sbin/ldconfig "$subpkgdir"/usr/sbin
}

i18n() {
  depends="$pkgname-bin"
  arch="noarch"
  mkdir -p "$subpkgdir"/usr/glibc-compat
  cp -a "$srcdir"/usr/glibc-compat/share "$subpkgdir"/usr/glibc-compat
}

sha512sums="
0aff0ec76f4d341957a792b8635c0770148eba9a5cb64f9bbd85228c14d9cb93c1a402063cab533a9f536f5f7be92c27bc5be8ed13c2b4f7aa416510c754d071  glibc-bin-2.35-0-x86_64.tar.gz
2912f254f8eceed1f384a1035ad0f42f5506c609ec08c361e2c0093506724a6114732db1c67171c8561f25893c0dd5c0c1d62e8a726712216d9b45973585c9f7  ld.so.conf
"
