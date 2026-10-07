import 'package:intl/intl.dart';

// Ex.: 30/09/2026 às 19:35
final DateFormat _formatoDataHora = DateFormat("dd/MM/yyyy 'às' HH:mm");

String formatarDataHora(DateTime data) => _formatoDataHora.format(data);
