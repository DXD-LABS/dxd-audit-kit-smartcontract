import { NextResponse } from 'next/server';
import { calculateBVSS } from '../../../lib/calculator';
import { loadConfig } from '../../../lib/data';
import { BVSSParams } from '../../../lib/types';

export async function POST(request: Request) {
  try {
    const body: Partial<BVSSParams> = await request.json();
    const config = loadConfig();
    const result = calculateBVSS(body, config);
    return NextResponse.json(result);
  } catch (error: any) {
    return NextResponse.json(
      { error: 'Invalid parameters or scoring logic failure', details: error.message },
      { status: 400 }
    );
  }
}
export async function GET() {
  return NextResponse.json({ error: 'Method Not Allowed' }, { status: 405 });
}
