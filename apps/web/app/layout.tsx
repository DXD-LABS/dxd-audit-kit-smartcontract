import type { Metadata } from "next";
import { Outfit, Fira_Code } from "next/font/google";
import "./globals.css";
import { ReportProvider } from '../context/ReportContext';
import Header from '../components/layout/Header';
import NavTabs from '../components/layout/NavTabs';
import { loadVulns } from '../lib/data';

const outfit = Outfit({
  variable: "--font-outfit",
  subsets: ["latin"],
});

const firaCode = Fira_Code({
  variable: "--font-fira-code",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "DXD Labs Security Suite — Smart Contract Auditing Portal",
  description: "Premium interactive security scorecard, vulnerability database, Sui Move pattern scanner, and audit report compiler.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const vulnCount = loadVulns().length;

  return (
    <html
      lang="en"
      className={`${outfit.variable} ${firaCode.variable} h-full`}
    >
      <body className="min-h-full flex flex-col">
        <ReportProvider>
          <Header vulnCount={vulnCount} />
          <NavTabs />
          <main>
            {children}
          </main>
        </ReportProvider>
      </body>
    </html>
  );
}
