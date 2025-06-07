// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../CustomItem/BackgroundContainer.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Informativa sulla Privacy',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.black, // AppBar trasparente
      elevation: 0, // Nessuna ombra per un look minimal
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const BackgroundContainer(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(0.85), // Sfondo semitrasparente
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Ridimensionamento dinamico
                  children: [
                    _buildSectionTitle('Introduzione'),
                    _buildSectionContent(
                      'La presente informativa sulla privacy descrive come raccogliamo, utilizziamo, divulghiamo e proteggiamo le informazioni personali che ti riguardano quando utilizzi la nostra applicazione. La tua privacy è importante per noi e ci impegniamo a proteggere i tuoi dati personali in conformità con le leggi e i regolamenti applicabili in materia di protezione dei dati, incluso il Regolamento Generale sulla Protezione dei Dati (GDPR).',
                    ),
                    _buildSectionTitle('Quali dati personali raccogliamo'),
                    _buildSectionContent(
                      'Raccogliamo esclusivamente il tuo indirizzo email quando ti registri alla nostra App. L\'indirizzo email è necessario per creare il tuo account, consentirti di accedere alla tua area riservata e inviarti comunicazioni relative all\'utilizzo dell\'App, come notifiche, aggiornamenti e assistenza.',
                    ),
                    _buildSectionTitle(
                        'Come utilizziamo i tuoi dati personali'),
                    _buildSectionContent(
                      'Utilizziamo il tuo indirizzo email esclusivamente per le seguenti finalità:\n'
                      '1. Creazione dell\'account: L\'indirizzo email è utilizzato per creare il tuo account unico e personalizzato all\'interno dell\'App.\n'
                      '2. Autenticazione: L\'indirizzo email serve per autenticarti e accedere alla tua area riservata.\n'
                      '3. Comunicazioni: Potremmo utilizzare il tuo indirizzo email per inviarti comunicazioni importanti relative all\'App, come notifiche, aggiornamenti, avvisi di sicurezza e risposte alle tue richieste di assistenza.',
                    ),
                    _buildSectionTitle(
                        'Con chi condividiamo i tuoi dati personali'),
                    _buildSectionContent(
                      'Non condividiamo il tuo indirizzo email con terzi, salvo nei seguenti casi:\n'
                      '1. Fornitori di servizi: Potremmo condividere i tuoi dati con fornitori di servizi di terze parti che ci assistono nell\'erogazione dei nostri servizi (ad esempio, fornitori di servizi cloud). Questi fornitori sono vincolati da accordi di riservatezza e sono autorizzati a utilizzare i tuoi dati solo per le finalità specificate.\n'
                      '2. Obblighi legali: Potremmo essere tenuti a divulgare i tuoi dati personali in risposta a una richiesta legittima da parte di un\'autorità giudiziaria o per conformarci a leggi o regolamenti applicabili.',
                    ),
                    _buildSectionTitle('Sicurezza dei tuoi dati'),
                    _buildSectionContent(
                      'Adottiamo misure di sicurezza tecniche e organizzative adeguate per proteggere i tuoi dati personali da accessi non autorizzati, alterazioni, divulgazioni o distruzioni. Tuttavia, tieni presente che nessuna trasmissione di dati su Internet o sistema di archiviazione elettronico può essere garantita al 100%.',
                    ),
                    _buildSectionTitle('I tuoi diritti'),
                    _buildSectionContent(
                      'Hai il diritto di:\n'
                      '1. Accesso: Richiedere l\'accesso ai tuoi dati personali.\n'
                      '2. Rettifica: Richiedere la rettifica dei tuoi dati personali inesatti.\n'
                      '3. Cancellazione: Richiedere la cancellazione dei tuoi dati personali.\n'
                      '4. Limitazione: Richiedere la limitazione del trattamento dei tuoi dati personali.\n'
                      '5. Opposizione: Opporti al trattamento dei tuoi dati personali.\n'
                      '6. Portabilità: Richiedere la portabilità dei tuoi dati personali.\n\n'
                      'Per esercitare i tuoi diritti, puoi contattarci all\'indirizzo email ewofitness@gmail.com.',
                    ),
                    _buildSectionTitle('Modifiche alla presente informativa'),
                    _buildSectionContent(
                      'Ci riserviamo il diritto di modificare la presente Informativa in qualsiasi momento. Ti informeremo di eventuali modifiche sostanziali pubblicando una nuova versione della Informativa sull\'App.',
                    ),
                    _buildSectionTitle('Contattaci'),
                    _buildSectionContent(
                      'Se hai domande o dubbi riguardanti la presente Informativa, puoi contattarci all\'indirizzo email ewofitness@gmail.com.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16, // Dimensione font ridotta
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14, // Font più piccolo per contenuti
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}
