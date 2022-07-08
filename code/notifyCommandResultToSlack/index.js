import 'dotenv/config';
import axios from 'axios';
import JANDI from './service/jandi';
import S3 from './service/s3';

const httpClient = axios.create({
  baseURL: process.env.JANDI_URL,
  headers: {
    Accept: 'application/vnd.tosslab.jandi-v2+json',
    'Content-Type': 'application/json',
  },
});
const jandi = new JANDI(httpClient);

const s3 = new S3();

export const handler = async (event) => {
  const { commandId, outputS3BucketName, status } = await JSON.parse(
    event.Records[0].Sns.Message
  );
  const commandResult = await s3.getStdOut(outputS3BucketName, commandId);

  const message = 'OSの自動遮断結果です。';
  const connectColor = status === 'Success' ? '#0073BB' : '#D13212';
  const connectInfo = [
    {
      title: 'Command Result',
      description: commandResult,
    },
  ];
  await jandi.sendMessage(message, connectColor, connectInfo);

  return {
    statusCode: 200,
    body: null,
  };
};
