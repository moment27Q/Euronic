# App Móvil de Traducción por Voz + Bluetooth

## 1) Visión del producto

Aplicación móvil enfocada en traducción en tiempo real para conversaciones con audífonos Bluetooth. La app capturará voz, transcribirá, traducirá usando API de traducción (proveedor chino), mostrará texto en pantalla y habilitará chat traducido. Incluye monetización por suscripciones con planes por funcionalidades.

Objetivo principal: ofrecer una experiencia fluida de conversación multilenguaje para viajeros, negocios y atención al cliente.

---

## 2) Funcionalidades clave (MVP + escalado)

### MVP (Fase 1)
- Emparejamiento y selección de audífonos Bluetooth.
- Captura de audio de micrófono y/o dispositivo Bluetooth.
- STT (Speech-to-Text): transcripción de voz en idioma origen.
- Traducción de texto a idioma destino (API externa china).
- TTS (Text-to-Speech): reproducción del resultado traducido.
- Traducción en pantalla en tiempo casi real.
- Historial local de traducciones.
- Chat 1 a 1 con traducción automática por mensaje.
- Autenticación básica (email, Google, Apple).
- Suscripciones (mensual/anual) para desbloquear funciones premium.

### Fase 2
- Modo conversación bidireccional con alternancia automática de idioma.
- Detección automática de idioma.
- Modo offline parcial (paquetes de idioma descargables).
- Compartir conversaciones/exportar transcript.
- Multi-dispositivo (tablet + web admin para soporte).

### Fase 3
- Traducción (OCR + traducción).
- Modo grupos/salas.
- Diccionario personalizado por industria.
- Analítica avanzada de uso y retención.

---

## 2.1) Flujo de pantallas principal (según mockups)

### Pantalla 1 - Apertura de app y activación de licencia
Esta pantalla es la puerta de entrada cuando el usuario abre la app por primera vez o no tiene sesión activa.

Elementos clave:
- Mensaje principal de marca ("Rompe fronteras con cada palabra").
- Campo/espacio para ingreso de código de licencia.
- Opción de escaneo QR para activar licencia.
- Botón Activar Licencia.
- Botón Iniciar Sesión.
- Accesos sociales (Facebook, Apple, Google).

Comportamiento esperado:
- Si el usuario activa licencia correctamente, puede avanzar a autenticación o crear cuenta.
- Si pulsa Iniciar Sesión, navega a la pantalla 2.
- Si el código es inválido, mostrar error claro y opción de reintento.

### Pantalla 2 - Login / Crear cuenta
Pantalla de autenticación del usuario.

Elementos clave:
- Tabs: Iniciar sesión y Crear cuenta.
- Campos: correo y contraseña.
- Opción ¿Has olvidado tu contraseña?.
- Botón principal Ingresar.
- Login social (Facebook, Apple, Google).
- Cierre de modal/pantalla con icono X.

Comportamiento esperado:
- Validación local de formato de correo y contraseña mínima.
- Login exitoso -> redirección a la pantalla 3 (home del cliente).
- Login fallido -> mensaje de error contextual.
- Recuperación de contraseña por email OTP o enlace seguro.

### Pantalla 3 - Interfaz principal tras login exitoso
Pantalla que verá el cliente autenticado (home/dashboard funcional).

Elementos clave:
- Saludo personalizado (ej. "Hola, Camila").
- Campo de entrada para iniciar conversación con IA.
- Accesos a módulos de traducción:
  - Modo traductor.
  - Traducción sin conexión.
  - Traductor en vivo.
  - Traducción de videollamada.
  - Traductor de audios.
- Barra de navegación inferior.
- Espacio para banner/promoción.

Comportamiento esperado:
- Esta pantalla solo se muestra con sesión válida.
- Cada tarjeta de módulo valida suscripción/plan antes de abrir función premium.
- Si no tiene plan adecuado, se muestra paywall.
- Mantener estado del usuario (token + perfil + plan activo) al reiniciar la app.

### Reglas de navegación entre las 3 pantallas
1. Splash/Inicio -> Pantalla 1.
2. Pantalla 1 -> Pantalla 2 (login) cuando usuario elige autenticarse.
3. Pantalla 2 -> Pantalla 3 cuando autenticación es correcta.
4. Si ya existe sesión válida al abrir app: Splash -> Pantalla 3 (saltando 1 y 2).
5. Logout desde pantalla 3 devuelve a pantalla 1.

### Requisitos técnicos derivados del flujo UI
- Implementar AuthGuard para proteger la pantalla 3.
- Manejo de sesión con accessToken + refreshToken.
- Persistencia segura de tokens (Keychain iOS / Keystore Android).
- Integrar deep links para activación por QR/licencia.
- Registrar eventos de analítica:
  - open_app
  - license_activation_started
  - license_activation_success
  - login_success
  - login_failed
  - module_opened
  - paywall_viewed

---

## 3) Stack tecnológico completo recomendado

## Frontend móvil
- *Framework:* Flutter (único código base para Android e iOS).
- *Lenguaje:* Dart.
- *Estado global:* Riverpod o BLoC.
- *Navegación:* go_router.
- *UI:* Material 3 + componentes custom.
- *Forms/validación:* flutter_form_builder + form_builder_validators.
- *Audio/Bluetooth:*
  - flutter_blue_plus (BLE).
  - APIs nativas de audio (Android AudioRecord/AAudio, iOS AVAudioSession) vía platform channels cuando se requiera bajo nivel.
  - record / just_audio para captura y reproducción.
- *Realtime y chat:* WebSocket (Socket.IO client o ws).
- *i18n en app:* i18next.
- *Persistencia local:* MMKV o SQLite.

## Backend y plataforma
- *API Backend:* NestJS (Node.js + TypeScript).
- *Arquitectura:* Clean Architecture + módulos por dominio.
- *Base de datos transaccional:* PostgreSQL.
- *Caché:* Redis (sesiones, cuotas, rate limiting).
- *Mensajería/eventos:* RabbitMQ o Kafka (si escala alto).
- *Realtime gateway:* Socket.IO o WebSocket nativo.
- *Storage:* S3 compatible (AWS S3, MinIO, OSS).
- *Autenticación:* JWT + refresh tokens + OAuth (Google/Apple).
- *Pagos/suscripciones:*
  - RevenueCat (recomendado para simplificar iOS/Android).
  - Integración con App Store Connect y Google Play Billing.
- *Orquestación de jobs:* BullMQ (colas de traducción/procesamiento).

## Servicios de IA y traducción
- *Proveedor de traducción (API china):* encapsulado en un TranslationProviderAdapter.
- *STT/TTS:*
  - Opción 1: proveedor único que incluya STT + TTS.
  - Opción 2: STT separado (Whisper-like/Cloud STT) y TTS separado.
- *Estrategia de resiliencia:* fallback entre proveedores cuando falle el principal.

## DevOps, seguridad y observabilidad
- *Contenedores:* Docker.
- *Orquestación cloud:* Kubernetes (cuando escale) o ECS/Cloud Run al inicio.
- *CI/CD:* GitHub Actions.
- *Infra as Code:* Terraform.
- *Monitoreo:* OpenTelemetry + Prometheus + Grafana.
- *Errores/crash móvil:* Sentry + Firebase Crashlytics.
- *Logs backend:* Loki/ELK.
- *Seguridad:*
  - HTTPS/TLS en todo el tráfico.
  - Cifrado en reposo (DB y backups).
  - Secret Manager (AWS/GCP/Azure).
  - Rate limiting + WAF.
  - Cumplimiento de privacidad (GDPR/ley local).

---

## 4) Arquitectura de alto nivel

1. App móvil captura audio desde micrófono/Bluetooth.
2. Servicio STT convierte voz a texto.
3. Backend solicita traducción al proveedor chino mediante adaptador.
4. Texto traducido se devuelve al cliente.
5. TTS genera audio traducido para reproducción en audífonos.
6. Conversación se guarda en historial (según plan y política de privacidad).
7. Módulo de suscripción valida acceso a funciones premium.

Patrón recomendado: *Hexagonal/Ports & Adapters* para intercambiar proveedores de traducción sin reescribir lógica de negocio.

---

## 5) Módulos funcionales

- auth: registro/login, OAuth, gestión de sesión.
- user-profile: idioma preferido, voz, zona horaria.
- bluetooth-audio: conexión y routing de audio.
- speech: STT y TTS.
- translation: motor de traducción + fallback.
- chat: mensajes, websocket, traducción por mensaje.
- subscriptions: planes, entitlement, facturación.
- history: historial, búsqueda, exportación.
- analytics: eventos de uso, funnels, retención.
- admin: gestión de idiomas, flags y soporte.

---

## 6) Planes de suscripción sugeridos

### Free
- Minutos limitados por mes.
- Idiomas principales con límite de uso.
- Chat traducido con cuota diaria.
- Anuncios opcionales.

### Pro
- Más minutos de voz/mes.
- Mayor velocidad y prioridad de traducción.
- Historial extendido.
- Sin anuncios.
- Descarga de algunos paquetes offline.

### Business
- Minutos altos/ilimitados según contrato.
- Glosarios personalizados.
- Exportación avanzada.
- Soporte prioritario.

Implementación técnica recomendada: *RevenueCat + validación en backend* de entitlements para evitar fraude.

---

## 7) Proceso de implementación (roadmap)

## Etapa 0 - Descubrimiento (1-2 semanas)
- Definir públicos objetivos y casos de uso.
- Alinear idiomas iniciales y SLA de traducción.
- Seleccionar proveedor chino y revisar costos/latencia.
- Definir cumplimiento legal y privacidad.

## Etapa 1 - Base técnica (2-3 semanas)
- Configurar monorepo (apps/mobile, apps/api, packages/shared).
- Pipeline CI/CD inicial.
- Autenticación, base de datos y modelo de usuarios.
- Logging, métricas y crash reporting.

## Etapa 2 - Núcleo de traducción (3-5 semanas)
- Captura de audio + STT.
- Integración de API de traducción.
- TTS y reproducción por audífonos.
- Pantalla principal de traducción en tiempo real.

## Etapa 3 - Chat y suscripciones (2-4 semanas)
- Chat con websocket y traducción por mensaje.
- Integración RevenueCat + paywall.
- Lógica de cuotas por plan.
- Métricas de conversión.

## Etapa 4 - QA, hardening y despliegue (2-3 semanas)
- Pruebas funcionales y de carga.
- Test de latencia por región.
- Auditoría de seguridad básica.
- Publicación en stores.

---

## 8) Flujo de despliegue

1. main protegido con PRs y checks obligatorios.
2. Build automático por tags:
   - mobile-v* -> build Android/iOS con Flutter + Fastlane.
   - api-v* -> deploy backend a cloud.
3. Ambientes:
   - dev, staging, production.
4. Feature flags para activaciones graduales.
5. Monitoreo post-release + rollback plan.

---

## 9) Calidad y testing

- *Unit tests:* Jest.
- *Integration tests:* Supertest (backend).
- *E2E móvil:* integration_test (Flutter) + Firebase Test Lab opcional.
- *Contract tests:* entre backend y proveedor de traducción.
- *Pruebas de audio/Bluetooth:* dispositivos físicos (no solo emulador).
- *KPIs mínimos:*
  - Latencia traducción < 1.5 s objetivo (según red).
  - Crash-free sessions > 99%.
  - Exactitud de traducción validada por idioma.

---

## 10) Riesgos principales y mitigación

- *Latencia alta de APIs externas:* caché, colas, fallback de proveedor.
- *Calidad desigual por idioma:* ranking de calidad por idioma y avisos al usuario.
- *Costo variable por minuto de audio:* límites por plan, throttling y optimización.
- *Restricciones de stores en suscripciones:* cumplimiento estricto de políticas Apple/Google.
- *Compatibilidad Bluetooth:* matriz de pruebas por marcas/modelos.

---

## 11) Estructura de repositorio sugerida

txt
root/
  apps/
    mobile/
    api/
  packages/
    shared-types/
    ui-kit/
    translation-sdk/
  infra/
    terraform/
    k8s/
  docs/
    architecture/
    product/


---

## 12) Definición de listo para producción

- App aprobada en App Store y Google Play.
- Suscripciones activas y validadas servidor-side.
- Monitoreo, alertas y dashboards operativos.
- SLA de traducción acordado y medido.
- Política de privacidad y términos publicados.
- Soporte y runbook de incidentes documentados.

---

## 13) Próximos pasos inmediatos

1. Confirmar proveedor chino exacto de traducción/STT/TTS.
2. Definir lista inicial de idiomas y prioridades.
3. Definir arquitectura Flutter (Riverpod o BLoC) y estrategia de platform channels para audio nativo.
4. Crear backlog técnico del MVP (sprints 1-4).
5. Montar repositorio base con CI/CD y módulos auth, translation, subscriptions.