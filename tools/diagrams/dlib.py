"""Pustaka kecil untuk membuat diagram SVG yang konsisten (dipakai untuk dokumentasi TaugeKu)."""
from PIL import ImageFont
from xml.sax.saxutils import escape

FONT_FILES = {
    'sans': '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
    'bold': '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
    'mono': '/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf',
}
_cache = {}
def tw(text, size, kind='sans'):
    """Lebar teks (piksel). DejaVu cukup lebar, jadi hasilnya aman untuk font lain."""
    key = (kind, size)
    if key not in _cache:
        _cache[key] = ImageFont.truetype(FONT_FILES[kind], size)
    return _cache[key].getlength(text)

# fill, stroke, judul, subjudul
RAMPS = {
    'purple': ('#EEEDFE', '#534AB7', '#3C3489', '#534AB7'),
    'teal':   ('#E1F5EE', '#0F6E56', '#085041', '#0F6E56'),
    'coral':  ('#FAECE7', '#993C1D', '#712B13', '#993C1D'),
    'pink':   ('#FBEAF0', '#993556', '#72243E', '#993556'),
    'gray':   ('#F1EFE8', '#5F5E5A', '#444441', '#5F5E5A'),
    'blue':   ('#E6F1FB', '#185FA5', '#0C447C', '#185FA5'),
    'green':  ('#EAF3DE', '#3B6D11', '#27500A', '#3B6D11'),
    'amber':  ('#FAEEDA', '#854F0B', '#633806', '#854F0B'),
    'red':    ('#FCEBEB', '#A32D2D', '#791F1F', '#A32D2D'),
}
INK = '#1f2937'
MUTED = '#6b7280'
LINE = '#6b7280'
BORDER = '#e5e7eb'
SANS = "-apple-system,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans',sans-serif"
MONO = "ui-monospace,'SF Mono',Menlo,Consolas,'DejaVu Sans Mono',monospace"

def wrap(text, size, maxw, kind='sans'):
    words = text.split(' ')
    lines, cur = [], ''
    for w in words:
        t = (cur + ' ' + w).strip()
        if tw(t, size, kind) <= maxw or not cur:
            cur = t
        else:
            lines.append(cur); cur = w
    if cur: lines.append(cur)
    return lines

class Svg:
    def __init__(self, w, h, title, desc):
        self.w, self.h, self.title, self.desc = w, h, title, desc
        self.parts = []
        self.ops = []

    def add(self, s): self.parts.append(s)

    def rect(self, x, y, w, h, fill='none', stroke='none', rx=8, sw=1, dash=None):
        self.ops.append(('rect', x, y, w, h, fill, stroke, rx, sw, dash))
        d = f' stroke-dasharray="{dash}"' if dash else ''
        self.add(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"{d}/>')

    def text(self, x, y, t, size=13, weight=400, fill=INK, anchor='start', kind='sans', italic=False):
        self.ops.append(('text', x, y, t, size, weight, fill, anchor, kind))
        _w = tw(t, size, 'mono' if kind == 'mono' else ('bold' if weight >= 600 else 'sans'))
        _x0 = x if anchor == 'start' else (x - _w/2 if anchor == 'middle' else x - _w)
        if _x0 < 2 or _x0 + _w > self.w - 2:
            print(f'  ! teks keluar kanvas: {t[:50]!r} x0={_x0:.0f} lebar={_w:.0f} kanvas={self.w}')
        fam = MONO if kind == 'mono' else SANS
        st = ' font-style="italic"' if italic else ''
        self.add(f'<text x="{x:.1f}" y="{y:.1f}" font-family="{fam}" font-size="{size}" font-weight="{weight}" fill="{fill}" text-anchor="{anchor}" dominant-baseline="central"{st}>{escape(t)}</text>')

    def box(self, x, y, w, h, title, sub=None, ramp='gray', ts=14, ss=12, dash=None, sw=1):
        f, s, t1, t2 = RAMPS[ramp]
        for t, sz, kd in ((title, ts, 'bold'), (sub, ss, 'sans')):
            if t and tw(t, sz, kd) > w - 16:
                print(f'  ! teks melebihi kotak: {t!r} ({tw(t, sz, kd):.0f} > {w-16:.0f})')
        self.rect(x, y, w, h, f, s, 8, sw, dash)
        if sub:
            self.text(x + w/2, y + h/2 - 11, title, ts, 600, t1, 'middle')
            self.text(x + w/2, y + h/2 + 11, sub, ss, 400, t2, 'middle')
        else:
            self.text(x + w/2, y + h/2, title, ts, 600, t1, 'middle')

    def pill(self, x, y, t, ramp='gray', size=11, weight=600, pad=8, h=20, anchor='start'):
        f, s, t1, _ = RAMPS[ramp]
        w = tw(t, size, 'bold' if weight >= 600 else 'sans') + pad*2
        x0 = x if anchor == 'start' else (x - w/2 if anchor == 'middle' else x - w)
        self.rect(x0, y - h/2, w, h, f, s, h/2, 0.8)
        self.text(x0 + w/2, y, t, size, weight, t1, 'middle')
        return w

    def line(self, x1, y1, x2, y2, end=True, start=False, dash=None, color=LINE, sw=1.5):
        self.ops.append(('poly', [(x1, y1), (x2, y2)], end, start, dash, color, sw))
        d = f' stroke-dasharray="{dash}"' if dash else ''
        me = ' marker-end="url(#ar)"' if end else ''
        ms = ' marker-start="url(#ar)"' if start else ''
        self.add(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}" stroke="{color}" stroke-width="{sw}" fill="none"{d}{me}{ms}/>')

    def poly(self, pts, end=True, dash=None, color=LINE, sw=1.5):
        self.ops.append(('poly', list(pts), end, False, dash, color, sw))
        d = f' stroke-dasharray="{dash}"' if dash else ''
        me = ' marker-end="url(#ar)"' if end else ''
        p = ' '.join(f'{x:.1f},{y:.1f}' for x, y in pts)
        self.add(f'<polyline points="{p}" stroke="{color}" stroke-width="{sw}" fill="none" stroke-linejoin="round"{d}{me}/>')

    def label(self, x, y, t, size=12, fill=MUTED, anchor='middle', bg=True, weight=400):
        """Teks dengan latar putih kecil agar terbaca di atas garis."""
        w = tw(t, size, 'sans') + 8
        if bg:
            x0 = x - w/2 if anchor == 'middle' else (x - 4 if anchor == 'start' else x - w + 4)
            self.rect(x0, y - 9, w, 18, '#ffffff', 'none', 4)
        self.text(x, y, t, size, weight, fill, anchor)

    def render(self):
        head = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.w}" height="{self.h}" viewBox="0 0 {self.w} {self.h}" role="img">'
                f'<title>{escape(self.title)}</title><desc>{escape(self.desc)}</desc>'
                '<defs><marker id="ar" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">'
                f'<path d="M2 1L8 5L2 9" fill="none" stroke="{LINE}" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></marker></defs>'
                f'<rect x="0.5" y="0.5" width="{self.w-1}" height="{self.h-1}" rx="12" fill="#ffffff" stroke="{BORDER}"/>')
        return head + ''.join(self.parts) + '</svg>\n'

    def save(self, path):
        open(path, 'w', encoding='utf-8').write(self.render())

def sequence(title, desc, lifelines, messages, spacing=170, margin=30, top=24, footer=None):
    """Diagram urutan. lifelines: [(judul, sub, ramp)]. messages: dict(f,t,label[,dash]) atau dict(f,self=True,label)."""
    n = len(lifelines)
    W = margin*2 + spacing*(n-1) + (spacing-20)
    xs = [margin + (spacing-20)/2 + i*spacing for i in range(n)]
    hw = spacing - 24
    # pra-hitung tinggi baris
    rows = []
    for m in messages:
        if m.get('self'):
            maxw = 210 if m['f'] < n-1 else 210
            lines = wrap(m['label'], 12, maxw)
            rows.append((m, lines, max(52, 18*len(lines) + 24)))
        else:
            span = abs(xs[m['t']] - xs[m['f']])
            lines = wrap(m['label'], 12, span - 18)
            rows.append((m, lines, 40 + 15*(len(lines)-1)))
    foot = footer or []
    H = top + 56 + sum(r[2] for r in rows) + 30 + (24*len(foot) + 8 if foot else 0)
    s = Svg(int(W), int(H), title, desc)
    # lifelines
    for i, (t, sub, ramp) in enumerate(lifelines):
        s.box(xs[i] - hw/2, top, hw, 48, t, sub, ramp, 13, 11)
        s.line(xs[i], top + 50, xs[i], H - 18 - ((24*len(foot) + 8) if foot else 0), end=False, dash='4 4', color='#cbd5e1', sw=1)
    y = top + 56
    k = 1
    for m, lines, hgt in rows:
        if m.get('self'):
            i = m['f']; x = xs[i]
            right = i < n-1
            dx = 34 if right else -34
            yy = y + 10
            s.poly([(x, yy), (x+dx, yy), (x+dx, yy+24), (x+3*(1 if dx>0 else -1), yy+24)], end=True)
            tx = x + dx + (8 if right else -8)
            for li, ln in enumerate(lines):
                full = (f'{k}. ' if li == 0 else '   ') + ln
                wbg = tw(full, 12) + 8
                s.rect((tx - 4) if right else (tx - wbg + 4), yy + 6 + li*16 - 9, wbg, 18, '#ffffff', 'none', 4)
                s.text(tx, yy + 6 + li*16, full, 12, 400, INK, 'start' if right else 'end')
        else:
            x1, x2 = xs[m['f']], xs[m['t']]
            sign = 1 if x2 > x1 else -1
            ly = y + 8 + 15*(len(lines)-1)
            mid = (x1+x2)/2
            for li, ln in enumerate(lines):
                s.text(mid, y + 8 + li*15, (f'{k}. ' if li == 0 else '') + ln, 12, 400, INK, 'middle')
            s.line(x1 + 3*sign, ly + 14, x2 - 3*sign, ly + 14, dash=m.get('dash'))
        y += hgt
        k += 1
    for i, ft in enumerate(foot):
        caption(s, H - 16 - 24*(len(foot)-1-i), ft)
    return s


def _pil_font(kind, size, weight, scale=2):
    k = 'mono' if kind == 'mono' else ('bold' if weight >= 600 else 'sans')
    return ImageFont.truetype(FONT_FILES[k], max(6, int(round(size*scale))))

def preview(svg, path, scale=2):
    """Pratinjau PNG kasar (tanpa rasterizer SVG) untuk memeriksa tata letak."""
    from PIL import Image, ImageDraw
    import math
    W, H = svg.w*scale, svg.h*scale
    img = Image.new('RGB', (int(W), int(H)), 'white')
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([1, 1, W-2, H-2], radius=24, outline='#e5e7eb', width=2)
    def dashed(p1, p2, color, w, dash):
        L = math.dist(p1, p2)
        if L == 0: return
        ux, uy = (p2[0]-p1[0])/L, (p2[1]-p1[1])/L
        on, off = [float(v)*scale for v in dash.split()[:2]]
        t = 0
        while t < L:
            e = min(t+on, L)
            d.line([(p1[0]+ux*t, p1[1]+uy*t), (p1[0]+ux*e, p1[1]+uy*e)], fill=color, width=w)
            t += on+off
    for op in svg.ops:
        if op[0] == 'rect':
            _, x, y, w, h, fill, stroke, rx, sw, dash = op
            box = [x*scale, y*scale, (x+w)*scale, (y+h)*scale]
            f = None if fill == 'none' else fill
            if dash and stroke != 'none':
                if f: d.rounded_rectangle(box, radius=rx*scale, fill=f)
                pts = [(box[0],box[1]),(box[2],box[1]),(box[2],box[3]),(box[0],box[3]),(box[0],box[1])]
                for a, b in zip(pts, pts[1:]): dashed(a, b, stroke, max(1,int(sw*scale)), dash)
            else:
                d.rounded_rectangle(box, radius=rx*scale, fill=f, outline=None if stroke=='none' else stroke, width=max(1,int(sw*scale)))
        elif op[0] == 'text':
            _, x, y, t, size, weight, fill, anchor, kind = op
            a = {'start':'lm','middle':'mm','end':'rm'}[anchor]
            d.text((x*scale, y*scale), t, font=_pil_font(kind, size, weight, scale), fill=fill, anchor=a)
        elif op[0] == 'poly':
            _, pts, end, start, dash, color, sw = op
            P = [(x*scale, y*scale) for x, y in pts]
            for a, b in zip(P, P[1:]):
                if dash: dashed(a, b, color, max(1,int(sw*scale)), dash)
                else: d.line([a, b], fill=color, width=max(1,int(sw*scale)))
            def head(tip, frm):
                ang = math.atan2(tip[1]-frm[1], tip[0]-frm[0]); L = 8*scale
                d.polygon([tip, (tip[0]-L*math.cos(ang-0.45), tip[1]-L*math.sin(ang-0.45)), (tip[0]-L*math.cos(ang+0.45), tip[1]-L*math.sin(ang+0.45))], fill=color)
            if end: head(P[-1], P[-2])
            if start: head(P[0], P[1])
    img.save(path)


def box3(s, x, y, w, h, title, sub, small, ramp='gray'):
    """Kotak dengan tiga baris teks."""
    f, st, t1, t2 = RAMPS[ramp]
    for t, sz, kd in ((title, 14, 'bold'), (sub, 12, 'sans'), (small, 11, 'sans')):
        if tw(t, sz, kd) > w - 16:
            print(f'  ! teks melebihi kotak: {t!r} ({tw(t, sz, kd):.0f} > {w-16:.0f})')
    s.rect(x, y, w, h, f, st, 8, 1)
    s.text(x + w/2, y + h/2 - 21, title, 14, 600, t1, 'middle')
    s.text(x + w/2, y + h/2, sub, 12, 400, t2, 'middle')
    s.text(x + w/2, y + h/2 + 20, small, 11, 400, t2, 'middle', italic=True)

def folder_card(s, x, y, w, title, sub, ramp, rows, ncols=1, rowh=22):
    f, st, t1, t2 = RAMPS[ramp]
    hdr = 46
    nrows = len(rows) if ncols == 1 else (len(rows) + 1)//2
    h = hdr + nrows*rowh + 12
    s.rect(x, y, w, h, '#ffffff', st, 10, 1)
    s.rect(x, y, w, hdr, f, st, 10, 1)
    s.rect(x + 1, y + hdr - 10, w - 2, 10, f, 'none', 0)
    s.line(x, y + hdr, x + w, y + hdr, end=False, color=st, sw=1)
    s.text(x + 14, y + 16, title, 13, 700, t1, kind='mono')
    s.text(x + 14, y + 33, sub, 11, 400, t2)
    if ncols == 1:
        namecol = max(tw(r[0], 12, 'mono') for r in rows) + 14
        for i, (name, note) in enumerate(rows):
            yy = y + hdr + 8 + i*rowh + rowh/2
            s.text(x + 14, yy, name, 12, 400, INK, kind='mono')
            s.text(x + 14 + namecol, yy, note, 11, 400, MUTED)
    else:
        cw = (w - 28)/2
        for i, name in enumerate(rows):
            c, r = divmod(i, nrows)
            yy = y + hdr + 8 + r*rowh + rowh/2
            s.text(x + 14 + c*cw, yy, name, 12, 400, INK, kind='mono')
    return h

def field_card(s, x, y, w, title, role, writer, ramp, fields, writer_ramp='gray', rowh=20):
    f, st, t1, t2 = RAMPS[ramp]
    hdr = 48
    h = hdr + len(fields)*rowh + 12
    s.rect(x, y, w, h, '#ffffff', st, 10, 1)
    s.rect(x, y, w, hdr, f, st, 10, 1)
    s.rect(x + 1, y + hdr - 10, w - 2, 10, f, 'none', 0)
    s.line(x, y + hdr, x + w, y + hdr, end=False, color=st, sw=1)
    s.text(x + 12, y + 16, title, 13, 700, t1, kind='mono')
    s.text(x + 12, y + 34, role, 10.5, 700, t2)
    if writer:
        s.pill(x + w - 10, y + 16, writer, writer_ramp, size=10, pad=7, h=18, anchor='end')
    keycol = max(tw(k, 11.5, 'mono') for k, _ in fields) + 14
    for i, (k, v) in enumerate(fields):
        yy = y + hdr + 8 + i*rowh + rowh/2
        s.text(x + 14, yy, k, 11.5, 400, INK, kind='mono')
        s.text(x + 14 + keycol, yy, v, 11.5, 400, MUTED, kind='mono')
    return h


def caption(s, y, text, size=12, maxw=None):
    """Catatan di bawah gambar: otomatis dibungkus agar tidak keluar kanvas. Mengembalikan jumlah baris."""
    maxw = maxw or (s.w - 60)
    lines = wrap(text, size, maxw)
    for i, ln in enumerate(lines):
        s.text(s.w/2, y + i*(size + 6), ln, size, 400, MUTED, 'middle', italic=True)
    return len(lines)
