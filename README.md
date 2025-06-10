# 🏠 Auction Property Curation MVP

This project is a **Minimum Viable Product (MVP)** designed to assist users in evaluating real estate auction listings by automatically extracting and comparing relevant market data, legal context, and potential risks.

## 🎯 Project Goal

Provide a simple, functional platform that helps users understand whether an auctioned property is worth further consideration, using public data and automated comparisons.

---

## 📦 Features

### ✅ Input
Users can provide:
- A **URL** from a real estate auction listing **OR**
- Basic property details: `address`, `area (m²)`, and `auction price`

### ✅ Output
The system will generate an automated summary report including:

1. **Market Comparison**
   - Average price per square meter (based on platforms like OLX, Viva Real, Zap Imóveis)
   - Difference between auction price and regional market price

2. **Risk Classification**
   - Auction type: **judicial** or **extrajudicial**
   - Property status: **occupied** or **vacant**
   - Legal risks: debts, annotations found in the auction notice

3. **Local Context Map (optional in MVP)**
   - Nearby services: hospitals, markets, schools
   - Crime rate (if public data is available)
   - Flood risk (Cemaden/IPT)

4. **Automated Legal Checklist**
   - Key alerts extracted from the auction document (simulated/hardcoded for now)

5. **Export**
   - Option to download the report as PDF (planned for later stage)

---

## 🛠️ Tech Stack

| Layer       | Technology         |
|-------------|--------------------|
| Frontend    | HTML + Tailwind CSS (initial MVP) |
| Backend     | Java 21 + Spring Boot |
| Database    | SQLite (lightweight, file-based) |
| Scraping    | Custom scraper for OLX/VivaReal (Python or Java) |
| Mapping     | OpenStreetMap (future integration) |
| External APIs | IBGE, Cemaden, etc. |

---

## 🧪 MVP Development Plan

### Phase 1 - Core Workflow
- [ ] Input field (link or manual entry)
- [ ] Local SQLite setup
- [ ] Static logic to simulate:
  - Price per m²
  - Legal checklist
  - Risk assessment

### Phase 2 - Dynamic Data Integration
- [ ] Scraper to extract regional prices per m²
- [ ] Fetch external context data (flood risk, crime, services)

### Phase 3 - UI and Export
- [ ] Simple UI to input and display results
- [ ] Option to export report to PDF

---

## 📁 Folder Structure

```bash
auction-curation-mvp/
│
├── backend/               # Spring Boot backend
│   ├── src/
│   └── ...
│
├── frontend/              # Tailwind-based frontend
│   └── index.html
│
├── data/                  # Static mocks or scraped data
│   └── price_samples.json
│
├── docs/                  # Legal checklist templates, sample notices
│
├── README.md
└── LICENSE
````

---

## ⚠️ Disclaimer

> **The information provided by this platform is for informational purposes only.**
> It is based on public data and automated analysis.
> **It does not constitute legal or investment advice.** Use at your own risk.

---

## 📌 Future Enhancements

* Advanced document parser for auction notices (PDF/DOC)
* User accounts & saved reports
* API access for B2B real estate investors
* Data enrichment with property photos, zoning, historical prices

---

## 🤝 Contributing

We welcome contributions!
Please open issues, suggest improvements or submit pull requests if you'd like to help.

---

## 📄 License

MIT License © 2025
