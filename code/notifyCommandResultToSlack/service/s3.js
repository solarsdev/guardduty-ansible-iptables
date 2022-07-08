import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';

export default class S3 {
  constructor() {
    this.client = new S3Client();
  }

  async getStdOut(bucketName, commandId) {
    const data = await this.client.send(
      new GetObjectCommand({
        Bucket: bucketName,
        Key: `${commandId}/instanceId/awsrunShellScript/0.awsrunShellScript/stdout`,
      })
    );
    let s3ResponseBody = '';
    for await (const chunk of data.Body) {
      s3ResponseBody += chunk;
    }
    return s3ResponseBody.trim();
  }
}
