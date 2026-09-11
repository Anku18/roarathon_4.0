class ClosureResolution {
  const ClosureResolution({
    required this.kicker,
    required this.title,
    required this.body,
    this.history = const [],
  });

  final String kicker;
  final String title;
  final String body;
  final List<String> history;
}

class ClosureNode {
  const ClosureNode({
    required this.id,
    required this.label,
    this.prompt,
    this.children = const [],
    this.resolution,
  });

  final String id;
  final String label;
  final String? prompt;
  final List<ClosureNode> children;
  final ClosureResolution? resolution;
}

abstract final class DummyClosure {
  static const title = 'Close broking account';
  static const kicker = 'BEFORE YOU CLOSE';
  static const intro =
      'Tell us why you want to close. Your Relationship Manager will call you on your registered number.';

  static const stillCloseLabel = 'Still close account';
  static const keepLabel = 'Okay';

  static const confirmTitle = 'Close this broking account?';
  static const confirmBody =
      'Your RM has not spoken to you yet. If you continue, ops would settle positions and close trading and demat. This prototype files a dummy request and signs you out.';

  static const rootPrompt = 'Why do you want to close?';

  static const _rmTitle = 'Your Relationship Manager will get back to you';
  static const _rmKicker = 'WE’LL CALL YOU';

  static const roots = <ClosureNode>[
    ClosureNode(
      id: 'brokerage',
      label: 'Brokerage / charges are high',
      prompt: 'Which charge is the issue?',
      children: [
        ClosureNode(
          id: 'trading',
          label: 'Trading charges',
          prompt: 'Which segment?',
          children: [
            ClosureNode(
              id: 'cash',
              label: 'Cash / delivery',
              resolution: ClosureResolution(
                kicker: _rmKicker,
                title: _rmTitle,
                body:
                    'You’ve flagged cash / delivery charges. We’ve noted this against your client ID. Your Relationship Manager will call on the registered mobile within one working day. No closure request has been submitted.',
              ),
            ),
            ClosureNode(
              id: 'fno',
              label: 'F&O',
              resolution: ClosureResolution(
                kicker: _rmKicker,
                title: _rmTitle,
                body:
                    'You’ve flagged F&O charges. We’ve noted this against your client ID. Your Relationship Manager will call on the registered mobile within one working day. No closure request has been submitted.',
              ),
            ),
            ClosureNode(
              id: 'com',
              label: 'Commodity',
              resolution: ClosureResolution(
                kicker: _rmKicker,
                title: _rmTitle,
                body:
                    'You’ve flagged commodity charges. We’ve noted this against your client ID. Your Relationship Manager will call on the registered mobile within one working day. No closure request has been submitted.',
              ),
            ),
          ],
        ),
        ClosureNode(
          id: 'amc',
          label: 'AMC charges',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve flagged account maintenance charges. We’ve noted this against your client ID. Your Relationship Manager will call on the registered mobile within one working day. No closure request has been submitted.',
          ),
        ),
        ClosureNode(
          id: 'dp',
          label: 'DP / demat charges',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve flagged DP / demat charges. We’ve noted this against your client ID. Your Relationship Manager will call on the registered mobile within one working day. No closure request has been submitted.',
          ),
        ),
      ],
    ),
    ClosureNode(
      id: 'service',
      label: 'Not happy with service',
      prompt: 'What went wrong?',
      children: [
        ClosureNode(
          id: 'tech',
          label: 'Technical issues',
          prompt: 'Where did it fail?',
          children: [
            ClosureNode(
              id: 'website',
              label: 'Website',
              resolution: ClosureResolution(
                kicker: _rmKicker,
                title: _rmTitle,
                body:
                    'You’ve flagged the website. The team will review your last tickets and your Relationship Manager will call within one working day. No closure request has been submitted.',
                history: [
                  '12 Aug · Chart freeze on Trade Tiger web',
                  '3 Sep · Login loop after password reset',
                ],
              ),
            ),
            ClosureNode(
              id: 'app',
              label: 'Mobile app',
              resolution: ClosureResolution(
                kicker: _rmKicker,
                title: _rmTitle,
                body:
                    'You’ve flagged the mobile app. The team will review your last tickets and your Relationship Manager will call within one working day. No closure request has been submitted.',
                history: [
                  '19 Aug · Order ticket stuck on submit',
                  '8 Sep · OTP delay on login',
                ],
              ),
            ),
          ],
        ),
        ClosureNode(
          id: 'desk',
          label: 'Call-and-trade / RM',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve flagged the desk / RM experience. A senior Relationship Manager will call on the registered mobile within one working day. No closure request has been submitted.',
          ),
        ),
        ClosureNode(
          id: 'research',
          label: 'Research quality',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve flagged research. The desk and your Relationship Manager will get back to you within one working day. No closure request has been submitted.',
          ),
        ),
      ],
    ),
    ClosureNode(
      id: 'personal',
      label: 'Personal',
      prompt: 'Closest match — no blank reason',
      children: [
        ClosureNode(
          id: 'inactive',
          label: 'Not actively trading',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve told us the account is inactive. Your Relationship Manager will call within one working day to talk through next steps. No closure request has been submitted.',
          ),
        ),
        ClosureNode(
          id: 'nri',
          label: 'Relocating / status change',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve flagged a status change. Your Relationship Manager will call within one working day with the right checklist. No closure request has been submitted.',
          ),
        ),
        ClosureNode(
          id: 'family',
          label: 'Family consolidating accounts',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve flagged a household consolidation. Your Relationship Manager will call within one working day. No closure request has been submitted.',
          ),
        ),
      ],
    ),
    ClosureNode(
      id: 'moving',
      label: 'Moving to another broker',
      prompt: 'Where are you moving?',
      children: [
        ClosureNode(
          id: 'discount',
          label: 'A discount broker',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve said you may move to a discount broker. Your Relationship Manager will call within one working day. No closure request has been submitted.',
          ),
        ),
        ClosureNode(
          id: 'bank',
          label: 'A bank’s broking arm',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve said you may move to a bank broker. Your Relationship Manager will call within one working day. No closure request has been submitted.',
          ),
        ),
        ClosureNode(
          id: 'prefer',
          label: 'Prefer not to say',
          resolution: ClosureResolution(
            kicker: _rmKicker,
            title: _rmTitle,
            body:
                'You’ve chosen not to name the broker. Your Relationship Manager will still call within one working day. No closure request has been submitted.',
          ),
        ),
      ],
    ),
  ];
}
