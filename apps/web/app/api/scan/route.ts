import { NextResponse } from 'next/server';
import { runCodeScanner } from '../../../lib/scanner';

export async function POST(request: Request) {
  try {
    const { code } = await request.json();
    if (typeof code !== 'string') {
      return NextResponse.json({ error: 'Code content must be a string' }, { status: 400 });
    }
    const findings = runCodeScanner(code);
    return NextResponse.json(findings);
  } catch (error: any) {
    return NextResponse.json(
      { error: 'Scanning parsing failure', details: error.message },
      { status: 400 }
    );
  }
}
export async function GET() {
  return NextResponse.json({ error: 'Method Not Allowed' }, { status: 405 });
}
