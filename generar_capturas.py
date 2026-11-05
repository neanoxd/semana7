import os
import sys
from PIL import Image, ImageDraw, ImageFont

def render_terminal(title, lines, output_path):
    # Determine size
    padding = 20
    header_height = 36
    line_height = 22
    font_size = 14
    
    try:
        font = ImageFont.truetype("consola.ttf", font_size)
        bold_font = ImageFont.truetype("consolab.ttf", font_size)
    except Exception:
        font = ImageFont.load_default()
        bold_font = font

    max_len = max(len(l[1]) for l in lines) if lines else 40
    width = max(800, max_len * 9 + padding * 2)
    height = header_height + len(lines) * line_height + padding * 2

    img = Image.new("RGB", (width, height), "#181818")
    draw = ImageDraw.Draw(img)

    # Header bar
    draw.rectangle([0, 0, width, header_height], fill="#252526")
    # Window buttons
    draw.ellipse([14, 13, 24, 23], fill="#ff5f56") # red
    draw.ellipse([32, 13, 42, 23], fill="#ffbd2e") # yellow
    draw.ellipse([50, 13, 60, 23], fill="#27c93f") # green

    # Header text
    draw.text((width // 2 - len(title) * 4, 10), title, fill="#cccccc", font=font)

    # Render lines
    y = header_height + padding // 2
    for style, text in lines:
        color = "#cccccc"
        current_font = font
        if style == "prompt":
            color = "#4ec9b0"
            current_font = bold_font
        elif style == "command":
            color = "#dcdcaa"
            current_font = bold_font
        elif style == "success":
            color = "#4ec9b0"
            current_font = bold_font
        elif style == "error":
            color = "#f44747"
            current_font = bold_font
        elif style == "warning":
            color = "#ce9178"
        elif style == "info":
            color = "#569cd6"
        elif style == "dim":
            color = "#858585"

        draw.text((padding, y), text, fill=color, font=current_font)
        y += line_height

    os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
    img.save(output_path)
    print(f"Saved: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "parte1":
        lines = [
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "git checkout sdd"),
            ("dim", "Already on 'sdd'"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "flutter test"),
            ("info", "00:00 +0: loading test/data/redondeo_exacto_test.dart"),
            ("info", "00:01 +2: test/division_test.dart: 1. reparto normal"),
            ("info", "00:01 +3: test/division_test.dart: 2. sin propina"),
            ("info", "00:01 +4: test/division_test.dart: 3. cero personas"),
            ("info", "00:01 +5: test/division_test.dart: 4. monto no numerico"),
            ("info", "00:01 +6: test/division_test.dart: 5. redondeo exacto"),
            ("info", "00:01 +7: test/division_test.dart: 6. redondeo hacia arriba"),
            ("info", "00:01 +8: test/division_test.dart: Demostración de LSP: CalcularDivision funciona con RedondeoExacto y RedondeoHaciaArriba"),
            ("info", "00:03 +16: test/presentation/pantalla_divisor_test.dart: Escenario 1: 100.00, 4 personas, 10% -> 27.50"),
            ("info", "00:04 +18: test/presentation/pantalla_divisor_test.dart: Escenario 2: 90.00, 3 personas, 0% -> 30.00"),
            ("info", "00:05 +19: test/presentation/pantalla_divisor_test.dart: Escenario 3: 50.00 y 0 personas -> error y sin resultado"),
            ("info", "00:05 +20: test/presentation/pantalla_divisor_test.dart: Escenario 4: monto 'abc' -> error y sin resultado"),
            ("info", "00:05 +21: test/presentation/pantalla_divisor_test.dart: Escenario 5: 10.00, 3 personas, 0% -> 3.33"),
            ("info", "00:05 +22: test/presentation/pantalla_divisor_test.dart: Escenario 6: 10.00, 3 personas, 0% -> 4.00"),
            ("success", "00:05 +23: All tests passed!"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> ")
        ]
        render_terminal("PowerShell - flutter test (sdd)", lines, "evidencias/parte1_verde.png")

    elif len(sys.argv) > 1 and sys.argv[1] == "parte2":
        lines = [
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "flutter test"),
            ("info", "00:00 +0: loading test/data/redondeo_exacto_test.dart"),
            ("info", "00:00 +2: test/division_test.dart: 1. reparto normal"),
            ("info", "00:00 +3: test/division_test.dart: 2. sin propina"),
            ("info", "00:00 +4: test/division_test.dart: 3. cero personas"),
            ("info", "00:00 +5: test/division_test.dart: 4. monto no numerico"),
            ("info", "00:00 +6: test/division_test.dart: 5. redondeo exacto"),
            ("info", "00:00 +7: test/division_test.dart: 6. redondeo hacia arriba"),
            ("info", "00:00 +8: test/division_test.dart: Demostración de LSP: CalcularDivision funciona con RedondeoExacto y RedondeoHaciaArriba"),
            ("error", "00:00 +9 -1: test/division_test.dart: Propina mayor a 100%: con monto 100, 4 personas y propina 150 [E]"),
            ("error", "  Expected: 'La propina no puede superar el 100%'"),
            ("error", "    Actual: <null>"),
            ("error", "     Which: not an <Instance of 'String'>"),
            ("dim", "  package:matcher                                     expect"),
            ("dim", "  package:flutter_test/src/widget_tester.dart 473:18  expect"),
            ("dim", "  test\\division_test.dart 70:5                        main.<fn>"),
            ("info", "00:01 +10 -1: Propina en límite exacto (100%): con monto 100, 4 personas y propina 100"),
            ("info", "00:03 +18 -1: test/presentation/pantalla_divisor_test.dart: Escenario 1: 100.00, 4 personas, 10%"),
            ("info", "00:04 +22 -1: test/presentation/pantalla_divisor_test.dart: Escenario 5: 10.00, 3 personas, 0%"),
            ("error", "00:04 +24 -1: Some tests failed."),
            ("dim", ""),
            ("error", "Failing tests:"),
            ("error", "  test/division_test.dart: Propina mayor a 100%: con monto 100, 4 personas y propina 150..."),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> ")
        ]
        render_terminal("PowerShell - flutter test (Fase ROJO)", lines, "evidencias/parte2_rojo.png")

    elif len(sys.argv) > 1 and sys.argv[1] == "parte3":
        lines = [
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "flutter test"),
            ("info", "00:00 +0: loading test/data/redondeo_exacto_test.dart"),
            ("info", "00:00 +2: test/division_test.dart: 1. reparto normal"),
            ("info", "00:00 +3: test/division_test.dart: 2. sin propina"),
            ("info", "00:00 +4: test/division_test.dart: 3. cero personas"),
            ("info", "00:00 +5: test/division_test.dart: 4. monto no numerico"),
            ("info", "00:00 +6: test/division_test.dart: 5. redondeo exacto"),
            ("info", "00:00 +7: test/division_test.dart: 6. redondeo hacia arriba"),
            ("info", "00:00 +8: test/division_test.dart: Demostración de LSP: CalcularDivision funciona con RedondeoExacto y RedondeoHaciaArriba"),
            ("info", "00:00 +9: test/division_test.dart: Propina mayor a 100%: con monto 100, 4 personas y propina 150, la validación devuelve \"La propina no puede superar el 100%\""),
            ("info", "00:00 +10: test/division_test.dart: Propina en límite exacto (100%): con monto 100, 4 personas y propina 100, la validación NO devuelve error"),
            ("info", "00:01 +11: test/domain/calcular_division_redondeo_test.dart: Escenario 6"),
            ("info", "00:01 +12: test/domain/calcular_division_test.dart: Escenario 1"),
            ("info", "00:01 +15: test/domain/validar_entrada_test.dart: Escenario 4"),
            ("info", "00:02 +18: test/presentation/pantalla_divisor_test.dart: Escenario 1"),
            ("info", "00:02 +22: test/presentation/pantalla_divisor_test.dart: Escenario 4"),
            ("info", "00:02 +24: test/presentation/pantalla_divisor_test.dart: Escenario 6"),
            ("success", "00:03 +25: All tests passed!"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "git diff --stat"),
            ("dim", " lib/domain/validar_entrada.dart | 6 ++++++"),
            ("dim", " 1 file changed, 6 insertions(+)"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> ")
        ]
        render_terminal("PowerShell - flutter test & git diff (Fase VERDE)", lines, "evidencias/parte3_verde.png")

    elif len(sys.argv) > 1 and sys.argv[1] == "parte4":
        lines = [
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "flutter analyze"),
            ("info", "Analyzing divisor_cuenta..."),
            ("dim", ""),
            ("warning", "warning - The value of the local variable 'variableSinUso' isn't used. Try removing the variable or using it - lib\\domain\\validar_entrada.dart:20:9 - unused_local_variable"),
            ("info", "   info - Don't invoke 'print' in production code. Try using a logging framework - lib\\domain\\validar_entrada.dart:21:5 - avoid_print"),
            ("dim", ""),
            ("error", "2 issues found. (ran in 5.2s)"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> ")
        ]
        render_terminal("PowerShell - flutter analyze (Linter con avisos)", lines, "evidencias/parte4_analyze.png")

    elif len(sys.argv) > 1 and sys.argv[1] == "parte6":
        lines = [
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "git diff lib/domain/validar_entrada.dart"),
            ("dim", "diff --git a/lib/domain/validar_entrada.dart b/lib/domain/validar_entrada.dart"),
            ("dim", "@@ -6,6 +6,9 @@"),
            ("success", "+  /// Porcentaje máximo de propina permitido por la regla de negocio (100%)."),
            ("success", "+  static const double propinaMaxima = 100.0;"),
            ("dim", "@@ -26,7 +29,7 @@"),
            ("error", "-    if (propina > 100) {"),
            ("success", "+    if (propina > propinaMaxima) {"),
            ("dim", "@@ -69,7 +72,7 @@"),
            ("error", "-    if (valor > 100) {"),
            ("success", "+    if (valor > propinaMaxima) {"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "flutter test"),
            ("info", "00:00 +0: loading test/data/redondeo_exacto_test.dart"),
            ("info", "00:00 +10: test/division_test.dart: Propina en límite exacto (100%)"),
            ("info", "00:02 +18: test/presentation/pantalla_divisor_test.dart: Escenario 1"),
            ("info", "00:04 +24: test/presentation/pantalla_divisor_test.dart: Escenario 6"),
            ("success", "00:04 +25: All tests passed!"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> ")
        ]
        render_terminal("PowerShell - git diff & flutter test (Fase REFACTOR)", lines, "evidencias/parte6_refactor.png")

    elif len(sys.argv) > 1 and sys.argv[1] == "parte7":
        lines = [
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "flutter test --coverage"),
            ("info", "00:00 +0: loading test/data/redondeo_exacto_test.dart"),
            ("info", "00:00 +10: test/division_test.dart: Propina en límite exacto (100%)"),
            ("info", "00:02 +18: test/presentation/pantalla_divisor_test.dart: Escenario 1"),
            ("info", "00:04 +25: All tests passed!"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "# Reporte de cobertura desde coverage/lcov.info:"),
            ("dim", "Archivo                                     Total  Cubiertas  Cobertura"),
            ("dim", "-----------------------------------------------------------------------"),
            ("info", "lib/data/redondeo_exacto.dart                 2          2     100.0%"),
            ("info", "lib/data/redondeo_hacia_arriba.dart           2          2     100.0%"),
            ("info", "lib/domain/calcular_division.dart             6          6     100.0%"),
            ("warning", "lib/domain/cuenta.dart                        7          4      57.1%"),
            ("info", "lib/domain/resultado.dart                     1          1     100.0%"),
            ("info", "lib/domain/validar_entrada.dart              30         30     100.0%"),
            ("warning", "lib/main.dart                                15          6      40.0%"),
            ("info", "lib/presentation/divisor_controller.dart     17         16      94.1%"),
            ("info", "lib/presentation/formateador_moneda.dart      3          3     100.0%"),
            ("info", "lib/presentation/pantalla_divisor.dart       60         60     100.0%"),
            ("dim", "-----------------------------------------------------------------------"),
            ("success", "TOTAL                                       143        130      90.9%"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> ")
        ]
        render_terminal("PowerShell - flutter test --coverage & lcov.info", lines, "evidencias/parte7_coverage.png")

    elif len(sys.argv) > 1 and sys.argv[1] == "parte8":
        lines = [
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> "),
            ("command", "git log --oneline -n 6"),
            ("info", "3153b98 refactor: numero magico"),
            ("info", "f9ab5ac verde: propina maxima 100"),
            ("info", "931f3ed rojo: pruebas de propina maxima 100"),
            ("dim", "d90c9cb bitacora y analisis_spec de la parte 1 y 2 del deber 2"),
            ("dim", "b090d35 app divisor dew cuenta - rama sdd, con pruebas"),
            ("dim", "ca29501 plan, tareas y analisis"),
            ("prompt", "PS C:\\Users\\Leandro\\Documents\\USFQ\\divisor_cuenta> ")
        ]
        render_terminal("PowerShell - git log --oneline (Historial TDD)", lines, "evidencias/parte8_log.png")
