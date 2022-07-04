export default class Slack {
  constructor(httpClient) {
    this.client = httpClient;
  }

  async sendMessage() {
    await this.client.post('', {
      username: 'webhookbot',
      icon_emoji: ':ghost:',
      attachments: [
        {
          fallback:
            'New open task [Urgent]: <http://url_to_task|Test out Slack message attachments>',
          pretext:
            'New open task [Urgent]: <http://url_to_task|Test out Slack message attachments>',
          color: '#D00000',
          fields: [
            {
              title: 'Notes',
              value: 'This is much easier than I thought it would be.',
              short: false,
            },
          ],
        },
      ],
    });
  }
}
