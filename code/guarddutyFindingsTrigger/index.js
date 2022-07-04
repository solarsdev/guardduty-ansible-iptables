import 'dotenv/config';
import axios from 'axios';
import Slack from './service/slack';

const httpClient = axios.create({
  baseURL: process.env.SLACK_WEBHOOK_URL,
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
  },
});
const slack = new Slack(httpClient);

export const handler = async (event) => {
  await slack.sendMessage();
};
